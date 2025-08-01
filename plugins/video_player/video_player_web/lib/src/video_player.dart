// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../hls.dart';
import 'duration_utils.dart';

// An error code value to error name Map.
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/code
const Map<int, String> _kErrorValueToErrorName = <int, String>{
  1: 'MEDIA_ERR_ABORTED',
  2: 'MEDIA_ERR_NETWORK',
  3: 'MEDIA_ERR_DECODE',
  4: 'MEDIA_ERR_SRC_NOT_SUPPORTED',
};

// An error code value to description Map.
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/code
const Map<int, String> _kErrorValueToErrorDescription = <int, String>{
  1: 'The user canceled the fetching of the video.',
  2: 'A network error occurred while fetching the video, despite having previously been available.',
  3: 'An error occurred while trying to decode the video, despite having previously been determined to be usable.',
  4: 'The video has been found to be unsuitable (missing or in a format not supported by your browser).',
};

// The default error message, when the error is an empty string
// See: https://developer.mozilla.org/en-US/docs/Web/API/MediaError/message
const String _kDefaultErrorMessage =
    'No further diagnostic information can be determined or provided.';

/// Wraps a [html.VideoElement] so its API complies with what is expected by the plugin.
class VideoPlayer {
  /// Create a [VideoPlayer] from a [html.VideoElement] instance.
  VideoPlayer({
    required web.HTMLVideoElement videoElement,
    @visibleForTesting StreamController<VideoEvent>? eventController,
  })  : _videoElement = videoElement,
        _eventController =
            eventController ?? StreamController<VideoEvent>.broadcast();

  final StreamController<VideoEvent> _eventController;
  final web.HTMLVideoElement _videoElement;

  bool _isBuffering = false;
  Hls? _hls;

  /// Returns the [Stream] of [VideoEvent]s from the inner [html.VideoElement].
  Stream<VideoEvent> get events => _eventController.stream;

  /// Initializes the wrapped [html.VideoElement].
  ///
  /// This method sets the required DOM attributes so videos can [play] programmatically,
  /// and attaches listeners to the internal events from the [html.VideoElement]
  /// to react to them / expose them through the [VideoPlayer.events] stream.
  void initialize() {
    _videoElement
      ..controls = false
      ..playsInline = true;

    _videoElement.onCanPlayThrough.listen((dynamic _) {
      setBuffering(false);
    });

    _videoElement.onPlaying.listen((dynamic _) {
      setBuffering(false);
    });

    _videoElement.onWaiting.listen((dynamic _) {
      setBuffering(true);
      _sendBufferingRangesUpdate();
    });

    // The error event fires when some form of error occurs while attempting to load or perform the media.
    _videoElement.onError.listen((web.Event _) {
      setBuffering(false);
      // The Event itself (_) doesn't contain info about the actual error.
      // We need to look at the HTMLMediaElement.error.
      // See: https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/error
      final web.MediaError error = _videoElement.error!;
      _eventController.addError(PlatformException(
        code: _kErrorValueToErrorName[error.code]!,
        message: error.message != '' ? error.message : _kDefaultErrorMessage,
        details: _kErrorValueToErrorDescription[error.code],
      ));
    });

    _videoElement.onEnded.listen((dynamic _) {
      setBuffering(false);
      _eventController.add(VideoEvent(eventType: VideoEventType.completed));
    });
  }

  /// Attempts to play the video.
  ///
  /// If this method is called programmatically (without user interaction), it
  /// might fail unless the video is completely muted (or it has no Audio tracks).
  ///
  /// When called from some user interaction (a tap on a button), the above
  /// limitation should disappear.
  Future<void> play() {
    return _videoElement.play().toDart.catchError((Object e) {
      // play() attempts to begin playback of the media. It returns
      // a Promise which can get rejected in case of failure to begin
      // playback for any reason, such as permission issues.
      // The rejection handler is called with a DOMException.
      // See: https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/play
      final web.DOMException exception = e as web.DOMException;
      _eventController.addError(PlatformException(
        code: exception.name,
        message: exception.message,
      ));
      return null;
    }, test: (Object e) => e is web.DOMException);
  }

  /// Pauses the video in the current position.
  void pause() {
    _videoElement.pause();
  }

  /// Controls whether the video should start again after it finishes.
  // ignore: use_setters_to_change_properties
  void setLooping(bool value) {
    _videoElement.loop = value;
  }

  /// Sets the volume at which the media will be played.
  ///
  /// Values must fall between 0 and 1, where 0 is muted and 1 is the loudest.
  ///
  /// When volume is set to 0, the `muted` property is also applied to the
  /// [web.HTMLVideoElement]. This is required for auto-play on the web.
  void setVolume(double volume) {
    assert(volume >= 0 && volume <= 1);

    // TODO(ditman): Do we need to expose a "muted" API?
    // https://github.com/flutter/flutter/issues/60721

    // If the volume is set to 0.0, only change muted attribute, but don't adjust the volume.
    _videoElement.muted = volume == 0.0;
    // Set the volume only if it's greater than 0.0.
    if (volume > 0.0) {
      _videoElement.volume = volume;
    }
  }

  void muted(bool value) {
    _videoElement.muted = value;
  }

  /// Sets the playback `speed`.
  ///
  /// A `speed` of 1.0 is "normal speed," values lower than 1.0 make the media
  /// play slower than normal, higher values make it play faster.
  ///
  /// `speed` cannot be negative.
  ///
  /// The audio is muted when the fast forward or slow motion is outside a useful
  /// range (for example, Gecko mutes the sound outside the range 0.25 to 4.0).
  ///
  /// The pitch of the audio is corrected by default.
  void setPlaybackSpeed(double speed) {
    assert(speed > 0);

    _videoElement.playbackRate = speed;
  }

  /// Moves the playback head to a new `position`.
  ///
  /// `position` cannot be negative.
  void seekTo(Duration position) {
    assert(!position.isNegative);

    _videoElement.currentTime = position.inMilliseconds.toDouble() / 1000;
  }

  /// Returns the current playback head position as a [Duration].
  Duration getPosition() {
    _sendBufferingRangesUpdate();
    return Duration(milliseconds: (_videoElement.currentTime * 1000).round());
  }

  /// Disposes of the current [web.VideoElement].
  void dispose() {
    _onCanPlayListener?.cancel();
    _onCanPlayListener = null;
    _videoElement.pause();
    _videoElement.currentTime = 0;
    _videoElement.srcObject = null;
    _videoElement.removeAttribute('src');
    _videoElement.load();
    _videoElement.remove();
    _hls?.stopLoad();
    _hls?.destroy();
  }

  // Sends an [VideoEventType.initialized] [VideoEvent] with info about the wrapped video.
  void _sendInitialized() {
    final Duration? duration =
        convertNumVideoDurationToPluginDuration(_videoElement.duration);

    final Size? size = _videoElement.videoHeight.isFinite
        ? Size(
            _videoElement.videoWidth.toDouble(),
            _videoElement.videoHeight.toDouble(),
          )
        : null;

    _eventController.add(
      VideoEvent(
        eventType: VideoEventType.initialized,
        duration: duration,
        size: size,
      ),
    );
  }

  /// Caches the current "buffering" state of the video.
  ///
  /// If the current buffering state is different from the previous one
  /// ([_isBuffering]), this dispatches a [VideoEvent].
  @visibleForTesting
  void setBuffering(bool buffering) {
    if (_isBuffering != buffering) {
      _isBuffering = buffering;
      _eventController.add(VideoEvent(
        eventType: _isBuffering
            ? VideoEventType.bufferingStart
            : VideoEventType.bufferingEnd,
      ));
    }
  }

  // Broadcasts the [web.HTMLVideoElement.buffered] status through the [events] stream.
  void _sendBufferingRangesUpdate() {
    _eventController.add(VideoEvent(
      buffered: _toDurationRange(_videoElement.buffered),
      eventType: VideoEventType.bufferingUpdate,
    ));
  }

  // Converts from [web.TimeRanges] to our own List<DurationRange>.
  List<DurationRange> _toDurationRange(web.TimeRanges buffered) {
    final List<DurationRange> durationRange = <DurationRange>[];
    for (int i = 0; i < buffered.length; i++) {
      durationRange.add(DurationRange(
        Duration(milliseconds: (buffered.start(i) * 1000).round()),
        Duration(milliseconds: (buffered.end(i) * 1000).round()),
      ));
    }
    return durationRange;
  }

  late final web.EventListener _videoClickListener = (web.Event event) {
    event.stopPropagation();
  }.toJS;

  late final web.EventListener _fullscreenChangeListener = (web.Event event) {
    if (_checkIsFullscreen()) {
      _addVideoEventListeners();
    } else {
      _removeVideoEventListeners();
    }
  }.toJS;
  bool _checkIsFullscreen() {
    final document = web.document;
    return document.fullscreenElement != null ||
        document.getProperty('webkitFullscreenElement'.toJS) != null ||
        document.getProperty('mozFullScreenElement'.toJS) != null ||
        document.getProperty('msFullscreenElement'.toJS) != null;
  }

  void _addVideoEventListeners() {
    _videoElement.addEventListener('click', _videoClickListener);
    _videoElement.addEventListener('pointerdown', _videoClickListener);
  }

  void _removeVideoEventListeners() {
    _videoElement.removeEventListener('click', _videoClickListener);
    _videoElement.removeEventListener('pointerdown', _videoClickListener);
    _videoElement.removeEventListener(
        'fullscreenchange', _fullscreenChangeListener);
  }

  void requestFullScreen() {
    final document = web.document;

    if (_checkIsFullscreen()) {
      document.exitFullscreen();
    } else {
      for (final method in [
        'requestFullscreen',
        'webkitEnterFullscreen',
        'webkitRequestFullscreen',
        'mozRequestFullScreen',
        'msRequestFullscreen'
      ]) {
        final jsMethod = method.toJS;
        if (_videoElement.hasProperty(jsMethod).toDart) {
          try {
            _videoElement.addEventListener(
                'fullscreenchange', _fullscreenChangeListener);
            _videoElement.callMethod(jsMethod);
            break;
          } catch (_) {}
        }
      }
    }
  }

  void exitFullScreen() {
    web.document.exitFullscreen();
  }

  StreamSubscription? _onCanPlayListener;
  FutureOr<void> changeVideo(String src) async {
    dispose();
    if (await _HlsHelper.shouldUseHlsLibrary(src)) {
      _hls = Hls(
        HlsConfig(
          xhrSetup: (web.XMLHttpRequest xhr, String _) {}.toJS,
        ),
      );
      _hls!.attachMedia(_videoElement);

      _hls!.on(
        'hlsMediaAttached',
        (String _, JSObject __) {
          _hls!.loadSource(src.toString());
        }.toJS,
      );

      _hls!.on(
          'hlsError',
          (String _, JSObject data) {
            try {
              final ErrorData _data = ErrorData(data);
              if (_data.fatal) {
                _eventController.addError(PlatformException(
                  code: _kErrorValueToErrorName[2]!,
                  message: _data.type,
                  details: _data.details,
                ));
              }
            } catch (_) {}
          }.toJS);
    } else {
      _videoElement.src = src;
      _videoElement.load();
    }

    _onCanPlayListener = _videoElement.onCanPlay.listen((dynamic _) {
      if (_onCanPlayListener == null) return;
      _sendInitialized();

      _onCanPlayListener?.cancel();
      _onCanPlayListener = null;
    });
  }
}

class _HlsHelper {
  static FutureOr<bool> shouldUseHlsLibrary(String src) async {
    if (_completer == null) {
      _canPlayHlsNatively();
    }
    if (shouldUse != null) {
      return shouldUse!;
    }

    shouldUse = !(await _completer!.future) &&
        isSupported() &&
        src.toString().contains('m3u8');

    return shouldUse!;
  }

  static Completer<bool>? _completer;

  static bool? shouldUse;

  static _canPlayHlsNatively() async {
    _completer = Completer<bool>();
    bool canPlayHls = false;
    try {
      final String canPlayType =
          web.HTMLVideoElement().canPlayType('application/vnd.apple.mpegurl');

      canPlayHls = canPlayType != '';
    } catch (_) {}

    if (!canPlayHls) {
      final script = web.HTMLScriptElement()
        ..type = "text/javascript"
        ..src = 'assets/packages/video_player_web/assets/hls.js';
      final head = web.document.head;
      head?.appendChild(script);

      await script.onLoad.first;
    }
    _completer!.complete(canPlayHls);
  }
}
