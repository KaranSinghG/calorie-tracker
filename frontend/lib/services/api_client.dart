import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';

class ApiClient {
  static String get _baseUrl => ApiConfig.baseUrl;

  Future<Map<String, String>> _headers({bool json = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final headers = <String, String>{
      if (token != null) 'Authorization': 'Bearer $token',
    };
    if (json) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final headers = await _headers(json: false);
    var uri = Uri.parse('$_baseUrl$path');
    if (query != null && query.isNotEmpty) {
      uri = uri.replace(queryParameters: query);
    }
    final response = await http.get(uri, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    throw ApiException('GET $path failed (${response.statusCode}): ${response.body}');
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final headers = await _headers();
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    throw ApiException('POST $path failed (${response.statusCode}): ${response.body}');
  }

  Future<void> delete(String path) async {
    final headers = await _headers(json: false);
    final response = await http.delete(
      Uri.parse('$_baseUrl$path'),
      headers: headers,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw ApiException('DELETE $path failed (${response.statusCode}): ${response.body}');
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}