// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.videoplayer;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.Surface;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import io.flutter.view.TextureRegistry;
import tv.danmaku.ijk.media.player.IjkMediaPlayer;
import tv.danmaku.ijk.media.player.IMediaPlayer;

final class VideoPlayer {
    private static final String TAG = "VideoPlayer";
    private Activity activity;
    private IjkMediaPlayer ijkMediaPlayer;
    private Surface surface;
    private final TextureRegistry.SurfaceTextureEntry textureEntry;
    private final VideoPlayerCallbacks videoPlayerEvents;
    private final VideoPlayerOptions options;
    private boolean isPlaybackCompleted = false;

    private boolean isLooping = false;

    /**
     * Creates a video player.
     *
     * @param context      application context.
     * @param events       event callbacks.
     * @param textureEntry texture to render to.
     * @param asset        asset to play.
     * @param options      options for playback.
     * @return a video player instance.
     */
    @NonNull
    static VideoPlayer create(
            Activity activity,
            Context context,
            VideoPlayerCallbacks events,
            TextureRegistry.SurfaceTextureEntry textureEntry,
            VideoAsset asset,
            String url,
            VideoPlayerOptions options) {
        IjkMediaPlayer.loadLibrariesOnce(null);
        IjkMediaPlayer.native_profileBegin("libijkplayer.so");
        return new VideoPlayer(activity, events, textureEntry, asset, url, options);
    }

    @VisibleForTesting
    VideoPlayer(
            Activity activity,
            VideoPlayerCallbacks events,
            TextureRegistry.SurfaceTextureEntry textureEntry,
            VideoAsset asset,
            String url,
            VideoPlayerOptions options) {
        this.activity = activity;
        this.videoPlayerEvents = events;
        this.textureEntry = textureEntry;
        this.options = options;
        ijkMediaPlayer = new IjkMediaPlayer();
        ijkMediaPlayer.setVolume(0f, 0f);
        try {
            ijkMediaPlayer.setDataSource(url);
            ijkMediaPlayer.prepareAsync();
        } catch (Exception e) {
            Log.wtf(TAG, "Error setting data source: " + e.getMessage());
        }

        setUpVideoPlayer();
    }

    private void setUpVideoPlayer() {
        surface = new Surface(textureEntry.surfaceTexture());
        ijkMediaPlayer.setSurface(surface);
        ijkMediaPlayer.setOnPreparedListener(mp -> {
            seekTo(0);
            int width = mp.getVideoWidth();
            int height = mp.getVideoHeight();
            String mCodecName = mp.getMediaInfo().mMeta.mVideoStream.mCodecName;

            if (width == 0 || height == 0) {
                mp.setOnInfoListener(null);
                pause();
                long duration = mp.getDuration();
                mp.setVolume(1.0f, 1.0f);
                videoPlayerEvents.onInitialized(width, height, duration, 0, mCodecName);
            }
        });
        ijkMediaPlayer.setOnCompletionListener(mp -> {
            if(isLooping) {
                seekTo(0);
                play();
            }
            else if(!isPlaybackCompleted) {
                isPlaybackCompleted = true;
                videoPlayerEvents.onCompleted();
            }

        });
        ijkMediaPlayer.setOnErrorListener((mp, what, extra) -> {
            Log.wtf(TAG, "IJKPlayer error: " + what + ", " + extra);
            return true;
        });
        ijkMediaPlayer.setOnBufferingUpdateListener((mp, percent) ->
                videoPlayerEvents.onBufferingUpdate(percent * mp.getDuration() / 100));
        ijkMediaPlayer.setOnInfoListener((mp, what, extra) -> {
            if (what == IMediaPlayer.MEDIA_INFO_VIDEO_RENDERING_START) {
                int width = mp.getVideoWidth();
                int height = mp.getVideoHeight();
                String mCodecName = mp.getMediaInfo().mMeta.mVideoStream.mCodecName;


                if(width != 0 && height != 0)  {
                    long duration = mp.getDuration();
                    mp.setOnInfoListener(null);
                    pause();
                    mp.setVolume(1.0f, 1.0f);
                    videoPlayerEvents.onInitialized(width, height, duration, 0, mCodecName);
                }
                return true;
            }
            return false;
        });
    }

    void play() {
        if(isPlaybackCompleted) {
            isPlaybackCompleted = false;
        }
        ijkMediaPlayer.start();
    }

    void pause() {
        ijkMediaPlayer.pause();
    }

    void setLooping(boolean value) {
        isLooping = value;
    }

    void setVolume(double value) {
        float bracketedValue = (float) Math.max(0.0, Math.min(1.0, value));
        ijkMediaPlayer.setVolume(bracketedValue, bracketedValue);
    }

    // 添加新的方法来设置亮度
    void setBrightness(double brightness) {
        if (activity == null) return;

        float brightnessValue = (float) Math.max(0.0, Math.min(1.0, brightness));

        activity.runOnUiThread(() -> {
            Window window = activity.getWindow();
            WindowManager.LayoutParams layoutParams = window.getAttributes();
            layoutParams.screenBrightness = brightnessValue;
            window.setAttributes(layoutParams);
        });
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

    void dispose() {
        textureEntry.release();
        if (surface != null) {
            surface.release();
        }
        if (ijkMediaPlayer != null) {
            ijkMediaPlayer.release();
        }
        IjkMediaPlayer.native_profileEnd();
    }
}
