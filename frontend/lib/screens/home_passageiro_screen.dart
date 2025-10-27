// lib/screens/home_passageiro_screen.dart

import 'package:flutter/material.dart';

class HomePassageiroScreen extends StatelessWidget {
  const HomePassageiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Column(
        children: [
          // 🔹 Topo azul com info do passageiro
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF3E51B5),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/perfil.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bem vindo',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Sofia Silva',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Image(
                      image: AssetImage('assets/images/logo_vanbora02.png'),
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Grade de botões principais
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildMenuIcon(Icons.directions_bus, 'Minha rota'),
                _buildMenuIcon(Icons.access_time, 'Horários'),
                _buildMenuIcon(Icons.person, 'Motorista'),
                _buildMenuIcon(Icons.chat_bubble_outline, 'Chat'),
                _buildMenuIcon(Icons.school, 'Faculdade'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Informações da rota
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Próxima viagem',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Cartão da rota
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.route, color: Colors.white, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Faculdade JK - Taguatinga', style: TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Horário de saída: 05:40', style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 4),
                        Text('Motorista: Kaio Lucas', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Confirmado', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Histórico de viagens
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Histórico recente',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildHistoricoItem('Faculdade JK', '05:40', true),
                _buildHistoricoItem('Faculdade Anhanguera', '05:45', false),
              ],
            ),
          ),
        ],
      ),

      // 🔹 Barra inferior
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Color(0xFF3E51B5),
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.home, color: Colors.white, size: 32),
            Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 32),
            Icon(Icons.person, color: Colors.white70, size: 32),
          ],
        ),
      ),
    );
  }

  // 🔸 Widget de ícone do menu
  static Widget _buildMenuIcon(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // 🔸 Widget de histórico
  static Widget _buildHistoricoItem(String destino, String horario, bool confirmado) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Text(destino, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: confirmado ? Colors.green : Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              confirmado ? 'Confirmado' : 'Cancelado',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Text(horario, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
