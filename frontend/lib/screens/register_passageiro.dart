// lib/screens/register_passageiro.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api.dart';
import 'login_screen.dart';

class RegisterPassageiroScreen extends StatefulWidget {
  const RegisterPassageiroScreen({super.key});

  @override
  State<RegisterPassageiroScreen> createState() => _RegisterPassageiroScreenState();
}

class _RegisterPassageiroScreenState extends State<RegisterPassageiroScreen> {
  final _formKey = GlobalKey<FormState>();
  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final confirmarEmailCtrl = TextEditingController();
  final usuarioCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  final confirmarSenhaCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  bool stayConnected = false;
  bool isLoading = false;

  Future<void> registerPassageiro() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final url = Uri.parse("${ApiConfig.baseUrl}/passageiros/");
    final body = {
      "nome": nomeCtrl.text,
      "email": emailCtrl.text,
      "senha": senhaCtrl.text,
      "telefone": telefoneCtrl.text,
    };

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passageiro registrado com sucesso!")),
        );

        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao registrar: ${res.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro de conexão: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Column(
        children: [
          // 🔹 Topo e logo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 100, bottom: 40),
            child: Image.asset('assets/images/logo_vanbora.png', height: 100),
          ),

          // 🔹 Corpo azul
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF3E51B5),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Registro de Passageiro',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),

                        _buildField('Nome completo', controller: nomeCtrl),
                        _buildField('Email', controller: emailCtrl),
                        _buildField('Confirmar Email', controller: confirmarEmailCtrl),
                        _buildField('Usuário', controller: usuarioCtrl),
                        _buildField('Senha', controller: senhaCtrl, isPassword: true),
                        _buildField('Confirme a senha', controller: confirmarSenhaCtrl, isPassword: true),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Checkbox(
                              value: stayConnected,
                              activeColor: Colors.black,
                              onChanged: (v) => setState(() => stayConnected = v ?? false),
                            ),
                            const Text(
                              'Mantenha-me conectado',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : registerPassageiro,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Registrar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Esqueci minha senha',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Campo de texto reutilizável
  Widget _buildField(String hint,
      {required TextEditingController controller, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (v) => v!.isEmpty ? 'Preencha este campo' : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
