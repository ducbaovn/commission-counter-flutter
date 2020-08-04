import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashUtil {
  static String hashSHA256(String data) =>
      sha256.convert(utf8.encode(data)).toString();

  static String hashBase64Encode(String data) =>
      base64Encode(utf8.encode(data));
}
