// lib/screens/register_motorista.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api.dart';
import 'login_screen.dart';

class RegisterMotoristaScreen extends StatefulWidget {
  const RegisterMotoristaScreen({super.key});

  @override
  State<RegisterMotoristaScreen> createState() => _RegisterMotoristaScreenState();
}

class _RegisterMotoristaScreenState extends State<RegisterMotoristaScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final confirmarEmailCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();
  final cnhCtrl = TextEditingController();
  final placaCtrl = TextEditingController();
  final modeloCtrl = TextEditingController();
  final capacidadeCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  final confirmarSenhaCtrl = TextEditingController();

  bool aceitarTermos = false;
  bool isLoading = false;

  Future<void> registerMotorista() async {
    if (!_formKey.currentState!.validate() || !aceitarTermos) return;
    if (emailCtrl.text != confirmarEmailCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Os emails não coincidem.")),
      );
      return;
    }
    if (senhaCtrl.text != confirmarSenhaCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem.")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse("${ApiConfig.baseUrl}/motoristas/");
    final body = {
      "nome": nomeCtrl.text,
      "email": emailCtrl.text,
      "telefone": "", // opcional
      "senha": senhaCtrl.text,
      "cpf": cpfCtrl.text,
      "cnh": cnhCtrl.text,
      "placa_van": placaCtrl.text,
      "modelo_veiculo": modeloCtrl.text,
      "capacidade_passageiros": capacidadeCtrl.text,
    };

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Motorista cadastrado com sucesso!")),
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
    return Scaffold(backgroundColor: Color(0xFF1F1F1F),
      body: Column(
        children: [
          // 🔹 Topo com logo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 100, bottom: 40),
            child: Image.asset('assets/images/logo_vanbora.png', height: 100),
          ),

          // 🔹 Área azul arredondada
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
                          'Registro de Motorista',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // 🔹 Campos
                        _buildField('Nome completo', controller: nomeCtrl),
                        _buildField('Email', controller: emailCtrl),
                        _buildField('Confirmar Email', controller: confirmarEmailCtrl),
                        _buildField('CPF', controller: cpfCtrl),
                        _buildField('Nº CNH', controller: cnhCtrl),
                        _buildField('Placa da van', controller: placaCtrl),
                        _buildField('Modelo do veículo', controller: modeloCtrl),
                        _buildField('Capacidade de passageiros', controller: capacidadeCtrl),
                        _buildField('Senha', controller: senhaCtrl, isPassword: true),
                        _buildField('Confirme a senha', controller: confirmarSenhaCtrl, isPassword: true),

                        const SizedBox(height: 12),

                        // 🔹 Checkbox termos
                        Row(
                          children: [
                            Checkbox(
                              value: aceitarTermos,
                              activeColor: Colors.black,
                              onChanged: (v) => setState(() => aceitarTermos = v ?? false),
                            ),
                            const Expanded(
                              child: Text(
                                'Aceito os termos de condição',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 🔹 Botão Registrar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : registerMotorista,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Color(0xFFFFFFFF))
                                : const Text('Cadastrar', style: TextStyle(fontSize: 18)),
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

  Widget _buildField(String hint,
      {required TextEditingController controller, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (v) => v!.isEmpty ? 'Preencha este campo' : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
