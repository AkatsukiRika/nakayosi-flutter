package jp.co.rika.nakayosi_flutter

import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.Player
import com.google.android.exoplayer2.SimpleExoPlayer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    companion object {
        private const val CHANNEL = "nakayosi_flutter.rika.co.jp/settings"
        private const val SUCCESS_CODE = 0
        private const val ERROR_CODE_INIT = "error_code_init"
        private const val ERROR_CODE_URL = "error_code_url"
    }
    private var player: Player? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initPlayerAndroid" -> {
                    initPlayer()
                    result.success(SUCCESS_CODE)
                }
                "playOnlineAudioAndroid" -> {
                    val url = call.argument<String>("url")
                    if (url != null && playOnlineAudio(url)) {
                        result.success(SUCCESS_CODE)
                    } else if (url != null) {
                        result.error(ERROR_CODE_INIT, "player has not been initialized", null)
                    } else {
                        result.error(ERROR_CODE_URL, "url param might be null", null)
                    }
                }
                "stopOnlineAudioAndroid" -> {
                    if (stopOnlineAudio()) {
                        result.success(SUCCESS_CODE)
                    } else {
                        result.error(ERROR_CODE_INIT, "player has not been initialized", null)
                    }
                }
                "releasePlayerAndroid" -> {
                    if (releasePlayer()) {
                        result.success(SUCCESS_CODE)
                    } else {
                        result.error(ERROR_CODE_INIT, "player has not been initialized", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * 当ExoPlayer未被初始化时，将其初始化
     */
    private fun initPlayer() {
        if (player == null) {
            player = SimpleExoPlayer.Builder(this).build()
        }
    }

    /**
     * 使用ExoPlayer播放在线音频
     * 成功返回true，失败返回false
     * @param url 音频URL
     */
    private fun playOnlineAudio(url: String): Boolean {
        val mediaItem = MediaItem.fromUri(url)
        player?.apply {
            setMediaItem(mediaItem)
            playWhenReady = true
            repeatMode = Player.REPEAT_MODE_ONE // 设置播放模式为单曲循环模式
            prepare()
            return true
        }
        return false
    }

    /**
     * 停止ExoPlayer当前的播放
     */
    private fun stopOnlineAudio(): Boolean {
        player?.apply {
            playWhenReady = false
            return true
        }
        return false
    }

    /**
     * 释放ExoPlayer资源
     */
    private fun releasePlayer(): Boolean {
        player?.apply {
            release()
            return true
        }
        return false
    }
}
