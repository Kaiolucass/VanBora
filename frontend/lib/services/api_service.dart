import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000'; // ou troque para seu IP real

  // 🔹 LOGIN — usado no login_screen.dart
  static Future<bool> login(String email, String senha) async {
    try {
      final url = Uri.parse('$baseUrl/login'); // ajuste conforme sua rota real
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao logar: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }

  // 🔹 CADASTRO DE MOTORISTA
  static Future<bool> registerMotorista(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('$baseUrl/motoristas/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erro ao cadastrar motorista: $e');
      return false;
    }
  }

  // 🔹 CADASTRO DE PASSAGEIRO
  static Future<bool> registerPassageiro(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('$baseUrl/passageiros/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erro ao cadastrar passageiro: $e');
      return false;
    }
  }
}
