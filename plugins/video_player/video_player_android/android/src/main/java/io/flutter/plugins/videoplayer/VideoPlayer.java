// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.videoplayer;
import android.content.Context;
import android.content.res.AssetManager;
import android.util.Log;
import android.view.Surface;
import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import io.flutter.plugin.common.EventChannel;
import io.flutter.view.TextureRegistry;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import tv.danmaku.ijk.media.player.IMediaPlayer;
import tv.danmaku.ijk.media.player.IjkEventListener;
import tv.danmaku.ijk.media.player.IjkMediaPlayer;
import tv.danmaku.ijk.media.player.misc.IMediaDataSource;

final class VideoPlayer {
  private IjkMediaPlayer ijkMediaPlayer;

  private Surface surface;

  private final TextureRegistry.SurfaceTextureEntry textureEntry;

  private QueuingEventSink eventSink;

  private final EventChannel eventChannel;

  @VisibleForTesting boolean isInitialized = false;

  private final VideoPlayerOptions options;

  VideoPlayer(
      Context context,
      EventChannel eventChannel,
      TextureRegistry.SurfaceTextureEntry textureEntry,
      String dataSource,
      String formatHint,
      @NonNull Map<String, String> httpHeaders,
      VideoPlayerOptions options) {
    this.eventChannel = eventChannel;
    this.textureEntry = textureEntry;
    this.options = options;

    IjkMediaPlayer ijkMediaPlayer = new IjkMediaPlayer();

    ijkMediaPlayer.addIjkEventListener((mp, what, arg1, arg2, extra) -> {
      if(what == IjkEventListener.BUFFERING_UPDATE){
       sendBufferingUpdate(arg1);
      }
    });

    ijkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "enable-position-notify", 1);
    ijkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "start-on-prepared", 0);

    try {
      if(dataSource != null && dataSource.startsWith("asset:///")){
        AssetManager assetManager = context.getAssets();
        InputStream is = assetManager.open(dataSource.replaceFirst("asset:///", ""));
        ijkMediaPlayer.setDataSource(new RawMediaDataSource(is));
      } else {
        ijkMediaPlayer.setDataSource(dataSource);
      }
    }catch (IOException e){
      e.printStackTrace();
    }catch (IllegalArgumentException e){
      e.printStackTrace();
    }catch (SecurityException e){
      e.printStackTrace();
    }catch (IllegalStateException e){
      e.printStackTrace();
    }

    setUpVideoPlayer(ijkMediaPlayer, new QueuingEventSink());
  }


  private void setUpVideoPlayer(IjkMediaPlayer ijkMediaPlayer, QueuingEventSink eventSink) {
    this.ijkMediaPlayer = ijkMediaPlayer;
    this.eventSink = eventSink;

    eventChannel.setStreamHandler(
        new EventChannel.StreamHandler() {
          @Override
          public void onListen(Object o, EventChannel.EventSink sink) {
            eventSink.setDelegate(sink);
          }

          @Override
          public void onCancel(Object o) {
            eventSink.setDelegate(null);
          }
        });

    surface = new Surface(textureEntry.surfaceTexture());
    ijkMediaPlayer.setSurface(surface);

    ijkMediaPlayer.setOnPreparedListener(mp -> {
      if (!isInitialized) {
        isInitialized = true;
        sendInitialized();
      }
    });
    ijkMediaPlayer.setOnInfoListener((mp, what, extra) -> {
      if (what == IMediaPlayer.MEDIA_INFO_BUFFERING_START) {
        setBuffering(true);
      } else if (what == IMediaPlayer.MEDIA_INFO_BUFFERING_END) {
        setBuffering(false);
      }
      return false;
    });

    ijkMediaPlayer.setOnCompletionListener(mp -> {
      mp.pause();
      mp.seekTo(0);
      if(!isLooping) {
        Map<String, Object> event = new HashMap<>();
        event.put("event", "completed");
        eventSink.success(event);
        return;
      }
      if(isLooping) {
        mp.start();
      }
    });

    ijkMediaPlayer.setOnErrorListener((mp, what, extra) -> {
      setBuffering(false);
      if (eventSink != null) {
        eventSink.error("VideoError", "Video player had error " + what, null);
      }
      return false;
    });

    ijkMediaPlayer.prepareAsync();


  }

  public void sendBufferingUpdate(int i) {
    Map<String, Object> event = new HashMap<>();
    event.put("event", "bufferingUpdate");
    List<? extends Number> range = Arrays.asList(0, i);
    // iOS supports a list of buffered ranges, so here is a list with a single range.
    event.put("values", Collections.singletonList(range));
    eventSink.success(event);
  }

  private boolean isBuffering = false;
  public void setBuffering(boolean buffering) {
    if (isBuffering != buffering) {
      isBuffering = buffering;
      Map<String, Object> event = new HashMap<>();
      event.put("event", isBuffering ? "bufferingStart" : "bufferingEnd");
      eventSink.success(event);
    }
  }

  void play() {
    ijkMediaPlayer.start();
  }

  void pause() {
    ijkMediaPlayer.pause();
  }


  private boolean isLooping = false;

  void setLooping(boolean value) {
    isLooping = value;
  }

  void setVolume(double value) {
    float bracketedValue = (float) Math.max(0.0, Math.min(1.0, value));
    ijkMediaPlayer.setVolume(bracketedValue, bracketedValue);
  }

  void setPlaybackSpeed(double value) {
    ijkMediaPlayer.setSpeed((float) value);
  }

  void seekTo(int location) {
    ijkMediaPlayer.seekTo(location);
  }

  long getPosition() {
    return ijkMediaPlayer.getCurrentPosition();
  }

  @SuppressWarnings("SuspiciousNameCombination")
  @VisibleForTesting
  void sendInitialized() {
    if (isInitialized) {
      Map<String, Object> event = new HashMap<>();
      event.put("event", "initialized");
      event.put("duration", ijkMediaPlayer.getDuration());

      if (ijkMediaPlayer != null && ijkMediaPlayer.getVideoWidth() > 0 && ijkMediaPlayer.getVideoHeight() > 0) {
        int width = ijkMediaPlayer.getVideoWidth();
        int height = ijkMediaPlayer.getVideoHeight();
        int rotationDegrees = 0;

//        try {
//          MediaMetadataRetriever retriever = new MediaMetadataRetriever();
//          retriever.setDataSource(ijkMediaPlayer.getDataSource());
//          String rotation = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION);
//          rotationDegrees = Integer.parseInt(rotation);
//          retriever.release();
//        } catch (Exception e) {
//          e.printStackTrace();
//        }
//        // Switch the width/height if video was taken in portrait mode
//        if (rotationDegrees == 90 || rotationDegrees == 270) {
//          width = ijkMediaPlayer.getVideoHeight();
//          height = ijkMediaPlayer.getVideoWidth();
//        }

        event.put("width", width);
        event.put("height", height);

//        if (rotationDegrees == 180) {
//          event.put("rotationCorrection", rotationDegrees);
//        }
      }

      eventSink.success(event);
    }
  }

  void dispose() {
    if (isInitialized) {
      ijkMediaPlayer.stop();
    }
    textureEntry.release();
    eventChannel.setStreamHandler(null);
    if (surface != null) {
      surface.release();
    }
    if (ijkMediaPlayer != null) {
      ijkMediaPlayer.release();
    }
  }
}


class RawMediaDataSource implements IMediaDataSource {
  private InputStream mIs;
  private long mPosition = 0;

  public RawMediaDataSource(InputStream is) {
    mIs = is;
  }

  @Override
  public int readAt(long position, byte[] buffer, int offset, int size) {
    if (size <= 0)
      return size;
    int length = -1;
    try {
      if (mPosition != position) {
        mIs.reset();
        mPosition = mIs.skip(position);
      }
      length = mIs.read(buffer, offset, size);
      mPosition += length;
    } catch (IOException e) {
      Log.e("DataSource", "failed to read" + e.getMessage());
    }
    return length;
  }

  @Override
  public long getSize() {
    long size = -1;
    try {
      size = mIs.available();
    } catch (IOException e) {
      Log.e("DataSource", "failed to get size" + e.getMessage());
    }
    return size;
  }

  @Override
  public void close() {
    if (mIs != null) {
      try {
        mIs.close();
        mIs = null;
      } catch (IOException e) {
        Log.e("DataSource", "failed to close" + e.getMessage());
      }
    }
  }

}