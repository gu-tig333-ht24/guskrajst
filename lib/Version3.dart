import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); 
  // Startar appen genom att köra MyApp-klassen.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo list',
      // Titeln på appen, visas i viss kontext som appens namn.

      theme: ThemeData(
        primarySwatch: Colors.blue,  
        // Appens färgtema är satt till blått.

        scaffoldBackgroundColor: Colors.grey[200],  
        // Bakgrundsfärgen för hela appen är satt till ljusgrå.
      ),
      home: const TodoHomePage(), 
      // Första sidan som visas när appen startar är TodoHomePage.
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
        // Överst i appen visas texten "ToDo list" i AppBar.

        backgroundColor: Colors.blue[600],  
        // AppBar är blåfärgad.

        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Funktionalitet för filtrering kan läggas till här senare.
            },
            itemBuilder: (BuildContext context) {
              return {'all', 'done', 'undone'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice), 
                  // Skapar tre val i menyn: all, done, och undone.
                );
              }).toList();
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(8), 
        // Lägger lite utrymme runt hela listan av uppgifter.

        children: [
          _buildTodoItem('Plugga'),
          _buildTodoItem('Gym'),
          _buildTodoItem('Träffa familjen'),
          _buildTodoItem('Ringa mormor'),
          _buildTodoItem('Gå på bio'),
          _buildTodoItem('Planera semester'),
          _buildTodoItem('Handla'), 
          // Dessa är alla uppgifter som visas på skärmen.
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Funktionalitet för att lägga till nya uppgifter kan läggas till här senare.
        },
        child: const Icon(Icons.add),  
        // Plusikonen på den flytande knappen används för att lägga till nya uppgifter.

        backgroundColor: Colors.blue[600],  
        // Färgen på knappen är blå.
      ),
    );
  }

  // Funktion som skapar varje uppgift i att-göra-listan.
  Widget _buildTodoItem(String title) {
    return ListTile(
      leading: const Icon(Icons.crop_square), 
      // En fyrkantig ikon visas till vänster om varje uppgift.

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,  
          // Textstorleken på uppgiften är satt till 18.
        ),
      ),

      trailing: IconButton(
        icon: const Icon(Icons.close),  
        // En kryssikon till höger om uppgiften för att eventuellt ta bort den.

        onPressed: () {
          // Här kan du lägga till funktionalitet för att ta bort uppgifter.
        },
      ),
    );
  }
}
