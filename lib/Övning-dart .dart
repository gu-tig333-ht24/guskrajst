//Variabel

void main() {
  var name = "Stefan";  // En variabel av typen string, inferens används.
  // String name = "Stefan";  // Detta är också korrekt men redundant om du använder var.

  var x = 22;  // En variabel av typen int, inferens används.
  // int x = 22;  // Detta är också korrekt men redundant om du använder var.

  // Dynamic-typad variabel som kan ändras till vilken datatyp som helst.
  dynamic firstName = "Stefan";  // Kan ändra typ senare om det behövs.

  // const och final för oföränderliga variabler.
  const String fullName = "Stefan";  // Konstanter måste tilldelas direkt vid deklaration.
  const String nickname = "Steffo";  // Final kan tilldelas senare men inte ändras efter det.

  String myName;  // myName är initialt null eftersom ingen värde är tilldelat.
  
  myName = "Steve";  // Nu tilldelas myName ett strängvärde.

  // Utskrifter
  print(name);
  print(x);
  print(nickname);
  print(myName);
}
__________________________________________________________________________________________________________________________________________________

//Datatyper

void main() {
  // String
  String firstName = "Stefan";  // String-variabel
  print("String: $firstName");

  // Int
  int myNum = 22;  // Heltalsvariabel
  print("int: $myNum");

  // Double
  double otherNum = 19.99;  // Flyttalsvariabel
  print("double: $otherNum");

  // Bool
  bool myBool = false;  // Boolean-variabel
  print("Bool: $myBool");

  // Dynamic - kan anta olika typer
  dynamic fullName = "Stefan Krajisnik";  // Startar som en sträng
  print("Dynamic: $fullName");
}
_________________________________________________________________________________________________________________________________________________

//Listor 

void main() {
  // Listor
  var myList = [1, 2, 3];  // Skapar en lista med tre element
  print(myList);
  print(myList[0]);  // Skriver ut första elementet i listan

  // Ändra ett element i listan
  myList[0] = 22;
  print(myList);

  // Skapa en tom lista
  var emptyList = [];
  print(emptyList);

  // Lägg till ett element i den tomma listan
  emptyList.add(22);
  print(emptyList);

  // Lägg till flera element i den tomma listan
  emptyList.addAll([1, 2, 3]);
  print(emptyList);

  // Lägg till på en specifik position
  myList.insert(3, 900);  // Infogar 900 på index 3
  print(myList);

  // Lägg till flera element på en specifik position
  myList.insertAll(1, [99, 12, 97]);  // Infogar flera element från index 1
  print(myList);

  // Blandad lista med olika datatyper
  var mixedList = [1, 2, 3, "Stefan", "Sasa"];
  print(mixedList);

  // Ta bort ett specifikt objekt från listan
  mixedList.remove("Stefan");
  print(mixedList);

  // Ta bort objekt på en specifik position
  mixedList.removeAt(2);  // Tar bort objektet på index 2
  print(mixedList);
}
_________________________________________________________________________________________________________________________________________________

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Att göra lista',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Map<String, dynamic>> _todoList = [
    {'task': 'Plugga', 'done': false},
    {'task': 'Gym', 'done': false},
    {'task': 'Träffa familjen', 'done': false},
    {'task': 'Ringa mormor', 'done': false},
    {'task': 'Gå på bio', 'done': false},
    {'task': 'Planera semester', 'done': false},
    {'task': 'Handla', 'done': false},
    {'task': 'Träffa vänner', 'done': false}
  ];

  String _filter = 'alla';

  void _addTodoItem(String task) {
    setState(() {
      _todoList.add({'task': task, 'done': false});
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  void _showAddTodoDialog() {
    String newTask = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lägg till ny uppgift"),
          content: TextField(
            onChanged: (value) {
              newTask = value;
            },
            decoration: const InputDecoration(hintText: "Skriv in uppgiften"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Lägg till"),
              onPressed: () {
                if (newTask.isNotEmpty) {
                  _addTodoItem(newTask);
                  Navigator.of(context).pop();
                }
              },
            ),
            ElevatedButton(
              child: const Text("Avbryt"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _filteredTodoList() {
    if (_filter == 'klara') {
      return _todoList.where((item) => item['done'] == true).toList();
    } else if (_filter == 'oklara') {
      return _todoList.where((item) => item['done'] == false).toList();
    }
    return _todoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Att göra lista'),
        backgroundColor: Colors.blue[600],
      ),
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
            const Divider(),  // Visuell separator mellan menyalternativ
            ListTile(
              leading: const Icon(Icons.filter_list),
              title: const Text('Alla uppgifter'),
              onTap: () {
                setState(() {
                  _filter = 'alla';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.done),
              title: const Text('Klara uppgifter'),
              onTap: () {
                setState(() {
                  _filter = 'klara';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Oklara uppgifter'),
              onTap: () {
                setState(() {
                  _filter = 'oklara';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredTodoList().length,
        itemBuilder: (BuildContext context, int index) {
          return _buildTodoItem(
              _filteredTodoList()[index]['task'], index, _filteredTodoList()[index]['done']);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoItem(String title, int index, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          leading: Checkbox(
            value: isDone,
            onChanged: (bool? value) {
              setState(() {
                _todoList[index]['done'] = value ?? false;
              });
            },
            activeColor: Colors.blue,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
              color: isDone ? Colors.green : Colors.black,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.redAccent,
            onPressed: () {
              _removeTodoItem(index);
            },
          ),
        ),
      ),
    );
  }
}

