import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());  // Startar appen genom att köra MyApp-klassen
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo list',  // Titeln på appen
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Sätter färgtemat för appen
        scaffoldBackgroundColor: Colors.grey[100],  // Bakgrundsfärg på skärmen
        fontFamily: 'Roboto',  // Standard typsnitt
      ),
      home: const TodoHomePage(),  // Hemskärmen visas genom TodoHomePage-klassen
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();  // Skapar tillståndet för Todo-sidan
}

class _TodoHomePageState extends State<TodoHomePage> {
  late Future<List<Todo>> futureTodos;  // Variabel för att hålla uppgifter från API:et
  final String apiKey = '8da3d703-7633-408a-8c2d-5c2a346154bc';  // API-nyckel
  final String apiUrl = 'https://todoapp-api.apps.k8s.gu.se/todos';  // API URL för att hämta uppgifter

  @override
  void initState() {
    super.initState();
    futureTodos = fetchTodos();  // Hämtar uppgifter när sidan initieras
  }

  // Hämtar alla uppgifter från API:et
  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('$apiUrl?key=$apiKey'));

    if (response.statusCode == 200) {  // Om anropet lyckas
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();  // Konverterar JSON-svar till lista av ToDo-objekt
    } else {
      throw Exception('Failed to load todos');  // Felmeddelande om det misslyckas
    }
  }

  // Lägger till en ny uppgift genom ett API-anrop
  Future<void> addTodo(String task) async {
    if (task.isEmpty) {
      return;  // Gör inget om uppgiften är tom
    }

    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': task, 'done': false}),  // Skickar ny uppgift till API
    );

    if (response.statusCode == 200) {  // Uppdaterar listan om det lyckas
      setState(() {
        futureTodos = fetchTodos();
      });
    } else {
      throw Exception('Failed to add todo');  // Felmeddelande om det misslyckas
    }
  }

  // Uppdaterar status på en uppgift (klar/inte klar)
  Future<void> updateTodoStatus(String id, String title, bool isDone) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': isDone}),  // Skickar uppdaterad status till API
    );

    if (response.statusCode == 200) {
      setState(() {
        futureTodos = fetchTodos();  // Uppdaterar uppgiftslistan
      });
    } else {
      throw Exception('Failed to update todo');  // Felmeddelande om det misslyckas
    }
  }

  // Tar bort en uppgift från API:et
  Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id?key=$apiKey'),
    );

    if (response.statusCode == 200) {
      setState(() {
        futureTodos = fetchTodos();  // Uppdaterar listan efter borttagning
      });
    } else {
      throw Exception('Failed to delete todo');  // Felmeddelande om det misslyckas
    }
  }

  // Visar en dialogruta för att lägga till en ny uppgift
  void _showAddTodoDialog() {
    String newTask = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lägg till ny uppgift"),
          content: TextField(
            onChanged: (value) {
              newTask = value;  // Sparar det användaren skriver
            },
            decoration: const InputDecoration(hintText: "Skriv in uppgiften"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Lägg till"),
              onPressed: () {
                if (newTask.isNotEmpty) {
                  addTodo(newTask);  // Lägger till uppgiften om den inte är tom
                  Navigator.of(context).pop();  // Stänger dialogrutan
                }
              },
            ),
            ElevatedButton(
              child: const Text("Avbryt"),
              onPressed: () {
                Navigator.of(context).pop();  // Stänger dialogrutan utan att göra något
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo list'),  // Titel på appbaren
        backgroundColor: Colors.blue[600],  // Färg på appbaren
      ),
      // En meny (Drawer) för att filtrera uppgifter
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Meny',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.filter_list),
              title: const Text('Alla uppgifter'),
              onTap: () {
                setState(() {
                  futureTodos = fetchTodos();  // Hämta alla uppgifter igen
                });
                Navigator.pop(context);  // Stänger menyn
              },
            ),
            ListTile(
              leading: const Icon(Icons.done),
              title: const Text('Klara uppgifter'),
              onTap: () {
                setState(() {
                  futureTodos = fetchTodos()
                      .then((list) => list.where((todo) => todo.done).toList());  // Filtrerar klara uppgifter
                });
                Navigator.pop(context);  // Stänger menyn
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Oklara uppgifter'),
              onTap: () {
                setState(() {
                  futureTodos = fetchTodos()
                      .then((list) => list.where((todo) => !todo.done).toList());  // Filtrerar oklara uppgifter
                });
                Navigator.pop(context);  // Stänger menyn
              },
            ),
          ],
        ),
      ),
      // Visar listan av uppgifter
      body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // Visar laddningsindikator medan data hämtas
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));  // Visar felmeddelande om något går fel
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Inga uppgifter att visa.'));  // Om det inte finns några uppgifter
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data!.length,  // Antalet uppgifter i listan
            itemBuilder: (BuildContext context, int index) {
              var todo = snapshot.data![index];  // Varje Todo-objekt
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.done,  // Markerar om uppgiften är klar eller inte
                      onChanged: (bool? value) {
                        updateTodoStatus(todo.id, todo.title, value ?? false);  // Uppdaterar status när checkbox ändras
                      },
                    ),
                    title: Text(
                      todo.title.isNotEmpty ? todo.title : 'Ingen titel',  // Visar uppgiftens titel
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: todo.done
                            ? TextDecoration.lineThrough  // Stryker över klar uppgift
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
                      onPressed: () {
                        deleteTodo(todo.id);  // Raderar uppgiften
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,  // Öppnar dialogrutan för att lägga till en ny uppgift
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.add),  // Plusikon för att lägga till uppgifter
      ),
    );
  }
}

class Todo {
  final String id;
  final String title;
  final bool done;

  Todo({
    required this.id,
    required this.title,
    required this.done,
  });

  // Konverterar JSON-data till ett Todo-objekt
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Ingen titel',  // Om titel saknas, sätt "Ingen titel"
      done: json['done'] as bool,  // Status om uppgiften är klar eller inte
    );
  }
}