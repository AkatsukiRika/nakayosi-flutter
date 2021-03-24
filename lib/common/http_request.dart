import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:alert/alert.dart';

class HttpConfig {
  // TODO: 展示前将baseUrl更换为云服务器上的地址
  static const baseUrl = 'http://192.168.43.234:3001';
  static const apiAskQuestion = '/api/main/getResultList';
  static const apiGetResult = '/api/main/getResultById';
  static const apiGetAudioList = '/api/audio/getServerAudioNameList';
  static const apiGetAudio = '/api/audio/getAudioStream';
  static const apiAddQuestion = '/api/question/addQuestion';
  static const apiAddProUser = '/api/user/addProUser';
  static const apiProUserLogin = '/api/user/userLogin';
  static const apiGetProUserStatus = '/api/user/getUserLoginStatus';
  static const apiProUserLogout = '/api/user/proUserLogout';
  static const apiAddAnswer = '/api/question/addAnswer';
  static const timeout = 10000;
}

class NkHttpRequest {
  static final BaseOptions options = BaseOptions(
    baseUrl: HttpConfig.baseUrl,
    connectTimeout: HttpConfig.timeout
  );
  static final Dio dio = Dio(options);
  static Future<T> request<T>(
    BuildContext context,
    String url,
    {String method = 'get', Map<String, dynamic> params, Map<String, dynamic> data}
  ) async {
    final options = Options(method: method);
    try {
      Response response = await dio.request<T>(
        url,
        queryParameters: params,
        data: data,
        options: options
      );
      return response.data;
    } on DioError catch (e) {
      Alert(message: e.toString()).show();
      return Future.error(e);
    }
  }
}