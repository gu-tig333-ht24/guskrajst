import 'package:flutter/material.dart';

// Det är viktigt att importera alla paket innan några deklarationer
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo list'),
        backgroundColor: Colors.blue[600],
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Filtreringsfunktionalitet kan läggas till här senare
            },
            itemBuilder: (BuildContext context) {
              return {'all', 'done', 'undone'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _buildTodoItem('Plugga'),
          _buildTodoItem('Gym'),
          _buildTodoItem('Träffa familjen'),
          _buildTodoItem('Ringa mormor'),
          _buildTodoItem('Gå på bio'),
          _buildTodoItem('Planera semester'),
          _buildTodoItem('Handla'),
          _buildTodoItem('Träffa vänner'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Funktionalitet för att lägga till nya uppgifter kan läggas till här senare
        },
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.add),
      ),
    );
  }

  // Funktion som skapar varje uppgift i att-göra-listan
  Widget _buildTodoItem(String title) {
    return ListTile(
      leading: const Icon(Icons.crop_square),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          // Funktionalitet för att ta bort uppgifter kan läggas till här senare
        },
      ),
    );
  }
}
