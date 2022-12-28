import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
class SharedConfig {
  static void setSDT(String sdt) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString("SDT", sdt);
  }

  static getSdt() async {
    final shared = await SharedPreferences.getInstance();
    return shared.containsKey("SDT") ? shared.getString("SDT") : "";
  }
 static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
