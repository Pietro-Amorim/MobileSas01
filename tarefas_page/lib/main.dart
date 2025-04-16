import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: HomeController(),
));

class HomeController extends StatefulWidget {
  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int _index = 0;

  final _pages = [
    LoginPage(),
    TarefasPage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tarefas'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final email = TextEditingController();
  final senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: email, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: senha, decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                final msg = (email.text.contains('@') && senha.text.length >= 6)
                    ? 'Login ok'
                    : 'Dados inválidos';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
              },
              child: Text('Logar', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

class TarefasPage extends StatefulWidget {
  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  List<String> pendentes = [];
  List<String> concluidas = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void adicionar() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        pendentes.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void remover(int index, bool isPendente) {
    setState(() {
      if (isPendente) pendentes.removeAt(index);
      else concluidas.removeAt(index);
    });
  }

  void concluir(int index) {
    setState(() {
      concluidas.add(pendentes[index]);
      pendentes.removeAt(index);
    });
  }

  void desfazer(int index) {
    setState(() {
      pendentes.add(concluidas[index]);
      concluidas.removeAt(index);
    });
  }

  void abrirResumo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResumoPage(
          pendentes: pendentes,
          concluidas: concluidas,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tarefas'),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {}, // Pode adicionar lógica de notificação
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: abrirResumo,
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Pendentes'),
              Tab(text: 'Concluídas'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(title: Text('Dashboard'), leading: Icon(Icons.dashboard)),
              ListTile(title: Text('Configurações'), leading: Icon(Icons.settings)),
              ListTile(title: Text('Ajuda'), leading: Icon(Icons.help)),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Nova tarefa',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: adicionar,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildLista(pendentes, true),
                  buildLista(concluidas, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLista(List<String> tarefas, bool isPendente) {
    return ListView.builder(
      itemCount: tarefas.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(tarefas[i]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPendente)
              IconButton(onPressed: () => concluir(i), icon: Icon(Icons.check, color: Colors.green)),
            if (!isPendente)
              IconButton(onPressed: () => desfazer(i), icon: Icon(Icons.undo, color: Colors.orange)),
            IconButton(onPressed: () => remover(i, isPendente), icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Este app permite:\n- Adicionar tarefas\n- Marcar como feitas\n- Remover\n\nFeito com Flutter!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}

class ResumoPage extends StatelessWidget {
  final List<String> pendentes;
  final List<String> concluidas;

  ResumoPage({required this.pendentes, required this.concluidas});

  @override
  Widget build(BuildContext context) {
    DateTime hoje = DateTime.now();
    String prazoMaisProximo = pendentes.isNotEmpty
        ? hoje.add(Duration(days: 1)).toString().split(' ')[0]
        : '-';

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações - Gerenciar tarefas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                buildCard('Pendentes', pendentes.length.toString(), Colors.orange),
                buildCard('Concluídas', concluidas.length.toString(), Colors.green),
                buildCard('Prazo mais próximo', prazoMaisProximo, Colors.blue),
                buildCard('Total', (pendentes.length + concluidas.length).toString(), Colors.purple),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  Text('Detalhamento:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Pendentes:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...pendentes.map((t) => Text('- $t')),
                  SizedBox(height: 10),
                  Text('Concluídas:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...concluidas.map((t) => Text('- $t')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
