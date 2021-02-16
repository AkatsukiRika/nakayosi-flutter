import 'dart:io';
import 'dart:math';

import 'package:alert/alert.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/common/http_request.dart';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';

class NkSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NkSettingsState();
}

class _NkSettingsState extends State<NkSettings> {
  bool isInfoInit = false;
  PackageInfo packageInfo;
  String versionName = GlobalStrings.defaultVersionName;
  String deviceId = GlobalStrings.defaultDeviceId;
  AudioPlayer audioPlayer;
  // 调用原生方法时需使用的Channel
  static const platform = const MethodChannel('nakayosi_flutter.rika.co.jp/settings');

  void _initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionName = packageInfo.version;
    });
  }

  void _initDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceId = iosDeviceInfo.identifierForVendor;
      });
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceId = androidDeviceInfo.androidId;
      });
    } else {
      setState(() {
        deviceId = GlobalStrings.unsupportedDeviceId;
      });
    }
  }

  void startAudioPlayback() async {
    // 请求服务器上的音频文件列表
    final audioListUrl = HttpConfig.baseUrl + HttpConfig.apiGetAudioList;
    final result = await NkHttpRequest.request(context, audioListUrl);
    try {
      final List<dynamic> audioList = result['data']['audioList'];
      // 拿到列表后，随机选择其中的一个文件开始播放
      final int randomIndex = Random().nextInt(audioList.length);
      final audioUrl = HttpConfig.baseUrl + HttpConfig.apiGetAudio + "/${audioList[randomIndex]}";
      print('audioUrl: $audioUrl');
      int playbackResult;
      if (Platform.isIOS) {
        playbackResult = await audioPlayer.play(audioUrl, isLocal: false);
      } else if (Platform.isAndroid) {
        playbackResult = await startAudioPlaybackAndroid(audioUrl);
      } else {
        // 不支持其他平台，直接弹Toast并让播放状态弹回去
        Alert(message: GlobalStrings.bgmUnsupported).show();
        playbackResult = 0;
      }
      if (playbackResult == 1) {
        setState(() {
          GlobalStates.isBgmOn = true;
        });
      } else {
        setState(() {
          GlobalStates.isBgmOn = false;
        });
      }
    } catch (e) {
      Alert(message: e.toString()).show();
      setState(() {
        GlobalStates.isBgmOn = false;
      });
    }
  }
  
  Future<int> startAudioPlaybackAndroid(String url) async {
    try {
      await platform.invokeMethod('initPlayerAndroid');
      await platform.invokeMethod('playOnlineAudioAndroid', {
        'url': url
      });
      return 1; // 成功结果
    } on PlatformException catch (e) {
      Alert(message: e.message).show();
      return 0; // 失败结果
    }
  }

  void stopAudioPlayback() async {
    int result;
    if (Platform.isIOS) {
      result = await audioPlayer.stop();
    } else if (Platform.isAndroid) {
      result = await stopAudioPlaybackAndroid();
    }
    if (result == 1) {
      setState(() {
        GlobalStates.isBgmOn = false;
      });
    }
  }

  Future<int> stopAudioPlaybackAndroid() async {
    try {
      await platform.invokeMethod('stopOnlineAudioAndroid');
      return 1;
    } on PlatformException catch (e) {
      Alert(message: e.message).show();
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    AudioPlayer.logEnabled = true;
    audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInfoInit) {
      _initPackageInfo();
      _initDeviceId();
      isInfoInit = true;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(GlobalStrings.titleSettings),
      ),
      body: ListView(
        children: [
          ListTile(
            dense: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(GlobalStrings.deviceId),
                Text(
                  deviceId,
                  style: TextStyle(color: GlobalColors.colorGrey),
                )
              ],
            ),
          ),
          Divider(
            thickness: 0.15,
            color: Colors.black,
            height: 0,
          ),
          ListTile(
            dense: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(GlobalStrings.versionName),
                Text(
                  versionName,
                  style: TextStyle(color: GlobalColors.colorGrey),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 0.15,
            color: Colors.black,
            height: 0,
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.fromLTRB(15, 0, 8, 0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(GlobalStrings.backgroundMusic),
                Transform.scale(
                  scale: 0.9,
                  child: CupertinoSwitch(
                    value: GlobalStates.isBgmOn,
                    onChanged: (bool currentValue) {
                      if (currentValue) {
                        startAudioPlayback();
                      } else {
                        stopAudioPlayback();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 0.15,
            color: Colors.black,
            height: 0,
          ),
        ],
      ),
    );
  }
}