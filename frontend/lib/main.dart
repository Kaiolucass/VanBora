import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔑 ADICIONA ISSO
  await dotenv.load(fileName: ".env");       // carrega o .env
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VanBora',
      home: TesteCadastro(),
    );
  }
}
m,.;
class TesteCadastro extends StatefulWidget {
  @override
  _TesteCadastroState createState() => _TesteCadastroState();
}

class _TesteCadastroState extends State<TesteCadastro> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final telefoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro Passageiro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nomeController, decoration: InputDecoration(labelText: "Nome")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: senhaController, decoration: InputDecoration(labelText: "Senha")),
            TextField(controller: telefoneController, decoration: InputDecoration(labelText: "Telefone")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var response = await ApiService.cadastrarPassageiro(
                  nome: nomeController.text,
                  email: emailController.text,
                  senha: senhaController.text,
                  telefone: telefoneController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Status: ${response.statusCode}")),
                );
              },
              child: Text("Cadastrar"),
            )
          ],
        ),
      ),
    );
  }
}
