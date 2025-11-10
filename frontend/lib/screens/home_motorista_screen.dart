// lib/screens/home_motorista_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

const Color _backgroundColor = Color(0xFF1F1F1F);
const Color _primaryColor = Color(0xFF3E51B5);
const Color _cardColor = Color(0xFF2C2C2C);
const Color _textColor = Colors.white;
const Color _secondaryTextColor = Colors.white70;

class HomeMotoristaScreen extends StatefulWidget {
  const HomeMotoristaScreen({super.key});

  @override
  State<HomeMotoristaScreen> createState() => _HomeMotoristaScreenState();
}

class _HomeMotoristaScreenState extends State<HomeMotoristaScreen> {
  String? nomeMotorista;
  String? userId;
  List<dynamic> viagens = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nomeMotorista = prefs.getString("nome") ?? "Motorista(a)";
      userId = prefs.getString("id");
    });

    if (userId != null) {
      await fetchViagens();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchViagens() async {
    setState(() => isLoading = true);
    try {
      final viagensUrl =
          Uri.parse("${ApiConfig.baseUrl}/viagem-passageiros/passageiro/$userId");
      final res = await http.get(viagensUrl);

      if (res.statusCode == 200) {
        viagens = jsonDecode(res.body);
      } else {
        viagens = [];
      }

      viagens.sort((a, b) => (a["horario_saida"] ?? "").compareTo(b["horario_saida"] ?? ""));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar passageiros: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildProfileAvatar() {
    if (nomeMotorista == null || nomeMotorista!.isEmpty) {
      return const CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white24,
        child: Icon(Icons.person, color: Colors.white, size: 30),
      );
    }

    final parts = nomeMotorista!.split(" ");
    final initials = parts.isNotEmpty
        ? (parts[0][0] + (parts.length > 1 ? parts.last[0] : ""))
        : "P";

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.white24,
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _menuButton(IconData icon, String label) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Atalho para $label clicado"))),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _primaryColor, size: 30),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: _secondaryTextColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPassengerState() {
    return const Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: [
          Icon(Icons.person_off, color: Colors.white70, size: 40),
          SizedBox(height: 10),
          Text(
            "Nenhum passageiro encontrado para esta van.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // 🔹 Novo: Card de passageiro
  Widget _buildPassageiroCard(Map<String, dynamic> viagem) {
    final nome = viagem["passageiro_nome"] ?? "Desconhecido";
    final confirmado = viagem["confirmado"] == true;
    final statusColor = confirmado ? Colors.green : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: _textColor),
              const SizedBox(width: 10),
              Text(
                nome,
                style: const TextStyle(
                  color: _textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              confirmado ? "Confirmado" : "Pendente",
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : RefreshIndicator(
              onRefresh: fetchViagens,
              color: _primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // 🔹 Cabeçalho
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
                      decoration: const BoxDecoration(
                        color: _primaryColor,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildProfileAvatar(),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Bem-vindo(a),",
                                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                                Text(
                                  nomeMotorista ?? "Motorista",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.bus_alert, color: Colors.white, size: 40)
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 🔹 Menu
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _menuButton(Icons.map, "Rotas"),
                            _menuButton(Icons.schedule, "Horários"),
                            _menuButton(Icons.notifications_active, "Avisos"),
                            _menuButton(Icons.chat_bubble_outline, "Chat"),
                            _menuButton(Icons.school, "Faculdades"),
                            _menuButton(Icons.settings, "Config."),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔹 Lista de passageiros
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Próximos passageiros",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: viagens.isEmpty
                          ? _buildEmptyPassengerState()
                          : Column(children: viagens.map((v) => _buildPassageiroCard(v)).toList()),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Rotas"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
