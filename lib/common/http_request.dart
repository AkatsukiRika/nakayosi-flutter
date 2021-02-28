import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:alert/alert.dart';

class HttpConfig {
  static const baseUrl = 'http://172.26.99.171:3001';
  static const apiAskQuestion = '/api/main/getResultList';
  static const apiGetResult = '/api/main/getResultById';
  static const apiGetAudioList = '/api/audio/getServerAudioNameList';
  static const apiGetAudio = '/api/audio/getAudioStream';
  static const apiAddQuestion = '/api/question/addQuestion';
  static const apiAddProUser = '/api/user/addProUser';
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