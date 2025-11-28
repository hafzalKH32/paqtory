import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "https://mockapi.example.com";

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse(baseUrl + endpoint);
    final res = await http.get(uri);
    return _handleResponse(res);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse(baseUrl + endpoint);
    final res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    return _handleResponse(res);
  }

  dynamic _handleResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    } else {
      throw Exception('API Error: ${res.statusCode} - ${res.body}');
    }
  }
}
