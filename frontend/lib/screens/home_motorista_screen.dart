// lib/screens/home_motorista_screen.dart

import 'package:flutter/material.dart';

class HomeMotoristaScreen extends StatelessWidget {
  const HomeMotoristaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Column(
        children: [
          // 🔹 Topo com fundo azul e perfil
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
                  backgroundImage: AssetImage('assets/images/perfil.png'), // imagem do motorista
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
                      'Kaio Lucas',
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

          // 🔹 Grade de botões
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildMenuIcon(Icons.local_shipping, 'Rotas'),
                _buildMenuIcon(Icons.access_time, 'Horários'),
                _buildMenuIcon(Icons.people, 'Passageiros'),
                _buildMenuIcon(Icons.chat_bubble_outline, 'Chat'),
                _buildMenuIcon(Icons.school, 'Faculdades'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Lista de passageiros
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Próximos passageiros',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildPassageiroItem('Kaio Lucas', 'Confirmado', '05:40', true),
                _buildPassageiroItem('Sofia Silva', 'Não Confirmado', '05:50', false),
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
            Icon(Icons.circle_outlined, color: Colors.white70, size: 32),
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

  // 🔸 Widget de passageiro
  static Widget _buildPassageiroItem(String nome, String status, String horario, bool confirmado) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/perfil.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(nome, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: confirmado ? Colors.green : Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Text(horario, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
