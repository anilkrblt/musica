import 'dart:convert';
import 'package:crypto/crypto.dart';

class Security {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool verifyPassword(String hashedPassword, String inputPassword) {
    final inputHash = hashPassword(inputPassword);
    return hashedPassword == inputHash;
  }
}
