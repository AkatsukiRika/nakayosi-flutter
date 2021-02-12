import 'dart:io';
import 'dart:math';

import 'package:alert/alert.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool isBgmOn = false;
  PackageInfo packageInfo;
  String versionName = GlobalStrings.defaultVersionName;
  String deviceId = GlobalStrings.defaultDeviceId;
  AudioPlayer audioPlayer;

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
      final playbackResult = await audioPlayer.play(audioUrl, isLocal: false);
      if (playbackResult == 1) {
        setState(() {
          isBgmOn = true;
        });
      } else {
        setState(() {
          isBgmOn = false;
        });
      }
    } catch (e) {
      Alert(message: e.toString()).show();
      setState(() {
        isBgmOn = false;
      });
    }
  }

  void stopAudioPlayback() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      setState(() {
        isBgmOn = false;
      });
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
                    value: isBgmOn,
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