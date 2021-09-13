import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class BaseService {
  static Future<dynamic> list(String url) async {
    final Uri uri = Uri.parse(url);
    final http.Response res = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(res.body);
    return json['data']['movies'] ?? <dynamic>[];
  }

  static Future<dynamic> get(String url) async {
    final Uri uri = Uri.parse(url);
    final http.Response res = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(res.body);
    return json['data'];
  }

  static Future<Uint8List> download(String url) async {
    final Uri uri = Uri.parse(url);
    final http.Response res = await http.get(uri);
    return res.bodyBytes;
  }
}
