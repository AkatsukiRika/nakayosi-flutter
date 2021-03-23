import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class NKUtils {
  static String stringToMd5(String data) {
    final content = Utf8Encoder().convert(data);
    final digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}