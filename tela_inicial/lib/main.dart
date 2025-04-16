import 'package:flutter/material.dart';
import 'package:tarefas_page/main.dart'; // ou o nome da tela, se for outra
/// Inicializa o aplicativo.
///
/// Chama o construtor de [MyApp] e passa o objeto resultante para
/// [runApp].
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Simples',
      home: TelaInicial(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  int _indiceSelecionado = 0;

  void _logar() {
    String email = _emailController.text.trim();
    String senha = _senhaController.text;

    if (!email.contains('@')) {
      _mostrarMensagem('Email inválido. Deve conter "@"');
    } else if (senha.length < 6) {
      _mostrarMensagem('Senha deve ter pelo menos 6 caracteres');
    } else {
      // ✅ Redireciona para a tela de tarefas
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TarefasPage()),
      );
    }
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _indiceSelecionado = index;
    });

    switch (index) {
      case 0:
        _mostrarMensagem("Tela Inicial");
        break;
      case 1:
        _mostrarMensagem("Tarefas");
        break;
      case 2:
        _mostrarMensagem("Mais info.");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facilitate the service ;)'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Center(
            child: Container(
              width: 300,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _senhaController,
                        decoration: InputDecoration(labelText: 'Senha'),
                        obscureText: true,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _logar,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                        child: Text('Logar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSelecionado,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Mais info.',
          ),
        ],
      ),
    );
  }
}
