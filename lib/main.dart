import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Detta är roten på hela applikationen. Det är en stateless widget, vilket betyder att den inte förändras över tid.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Att göra lista',  // Appens titel som visas på vissa ställen
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Definierar huvudfärgen för appens tema
        scaffoldBackgroundColor: Colors.grey[100],  // Bakgrundsfärg för hela appen
        fontFamily: 'Roboto',  // Standardfont för appen
      ),
      home: const TodoHomePage(),  // Startar TodoHomePage som huvudskärmen för appen
    );
  }
}

// Skapar den stateful widget som representerar startsidan i applikationen
class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

// Detta är den klass som hanterar logiken för TodoHomePage
class _TodoHomePageState extends State<TodoHomePage> {
  // Lista med uppgifter, varje uppgift är en karta med 'task' (uppgiftens namn) och 'done' (om uppgiften är avklarad eller ej)
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

  // Variabel för att hålla reda på vilket filter som är valt (alla, klara eller oklara uppgifter)
  String _filter = 'alla';

  // Funktion för att lägga till en ny uppgift i listan
  void _addTodoItem(String task) {
    setState(() {
      _todoList.add({'task': task, 'done': false});  // Lägger till ny uppgift med status 'inte klar'
    });
  }

  // Funktion för att ta bort en uppgift från listan baserat på dess index
  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);  // Tar bort uppgiften på den angivna positionen
    });
  }

  // Visar en dialogruta där användaren kan skriva in en ny uppgift
  void _showAddTodoDialog() {
    String newTask = '';  // Variabel för att hålla den nya uppgiften
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lägg till ny uppgift"),  // Titel för dialogrutan
          content: TextField(
            onChanged: (value) {
              newTask = value;  // Sparar det användaren skriver in
            },
            decoration: const InputDecoration(hintText: "Skriv in uppgiften"),
          ),
          actions: <Widget>[
            // Knapp för att lägga till den nya uppgiften
            ElevatedButton(
              child: const Text("Lägg till"),
              onPressed: () {
                if (newTask.isNotEmpty) {  // Kollar att uppgiften inte är tom
                  _addTodoItem(newTask);  // Lägger till uppgiften
                  Navigator.of(context).pop();  // Stänger dialogrutan
                }
              },
            ),
            // Knapp för att avbryta och stänga dialogrutan
            ElevatedButton(
              child: const Text("Avbryt"),
              onPressed: () {
                Navigator.of(context).pop();  // Stänger dialogrutan utan att lägga till något
              },
            ),
          ],
        );
      },
    );
  }

  // Funktion för att filtrera listan med uppgifter baserat på vilket filter som är valt
  List<Map<String, dynamic>> _filteredTodoList() {
    if (_filter == 'klara') {
      return _todoList.where((item) => item['done'] == true).toList();  // Returnerar bara klara uppgifter
    } else if (_filter == 'oklara') {
      return _todoList.where((item) => item['done'] == false).toList();  // Returnerar bara oklara uppgifter
    }
    return _todoList;  // Returnerar alla uppgifter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Att göra lista'),  // Titel för appens översta bar
        backgroundColor: Colors.blue[600],  // Färg på AppBar
      ),
      // Sidomenyn (Drawer) som visas när man sveper från vänster
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,  // Färg på sidomenyns övre sektion
              ),
              child: Text(
                'Meny',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const Divider(),  // Visuell linje som delar upp sektionerna
            // Menyalternativ för att visa alla uppgifter
            ListTile(
              leading: const Icon(Icons.filter_list),
              title: const Text('Alla uppgifter'),
              onTap: () {
                setState(() {
                  _filter = 'alla';  // Ändrar filtret till "alla"
                });
                Navigator.pop(context);  // Stänger menyn
              },
            ),
            // Menyalternativ för att visa bara klara uppgifter
            ListTile(
              leading: const Icon(Icons.done),
              title: const Text('Klara uppgifter'),
              onTap: () {
                setState(() {
                  _filter = 'klara';  // Ändrar filtret till "klara"
                });
                Navigator.pop(context);  // Stänger menyn
              },
            ),
            // Menyalternativ för att visa bara oklara uppgifter
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Oklara uppgifter'),
              onTap: () {
                setState(() {
                  _filter = 'oklara';  // Ändrar filtret till "oklara"
                });
                Navigator.pop(context);  // Stänger menyn
              },
            ),
          ],
        ),
      ),
      // Huvudinnehåll där listan med uppgifter visas
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredTodoList().length,  // Antalet uppgifter som ska visas
        itemBuilder: (BuildContext context, int index) {
          return _buildTodoItem(
              _filteredTodoList()[index]['task'], index, _filteredTodoList()[index]['done']);  // Bygger varje uppgift i listan
        },
      ),
      // Knappen för att lägga till en ny uppgift
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,  // När knappen trycks visas dialogrutan för att lägga till en ny uppgift
        backgroundColor: Colors.blue[600],  // Färg på knappen
        child: const Icon(Icons.add),  // Ikon på knappen
      ),
    );
  }

  // Bygger varje uppgift i listan som en ListTile med en checkbox och radera-knapp
  Widget _buildTodoItem(String title, int index, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        elevation: 2,  // Skapar en skuggeffekt runt uppgiften
        borderRadius: BorderRadius.circular(8),  // Gör kanterna runda
        child: ListTile(
          leading: Checkbox(
            value: isDone,  // Om uppgiften är markerad som klar
            onChanged: (bool? value) {
              setState(() {
                _todoList[index]['done'] = value ?? false;  // Uppdaterar uppgiftens status (klar/inte klar)
              });
            },
            activeColor: Colors.blue,  // Färg på checkboxen när den är markerad
          ),
          title: Text(
            title,  // Visar namnet på uppgiften
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,  // Genomstruken text om uppgiften är klar
              color: isDone ? Colors.green : Colors.black,  // Färg beroende på om uppgiften är klar eller inte
            ),
          ),
          // Radera-knappen för att ta bort uppgiften
          trailing: IconButton(
            icon: const Icon(Icons.close),  // Röd kryssikon för att radera
            color: Colors.redAccent,  // Färgen på radera-knappen
            onPressed: () {
              _removeTodoItem(index);  // Tar bort uppgiften när knappen trycks
            },
          ),
        ),
      ),
    );
  }
}
