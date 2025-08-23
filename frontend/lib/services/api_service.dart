import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:8000';

  static Future cadastrarPassageiro({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/passageiros/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'telefone': telefone,
      }),
    );
    return response;
  }
}
