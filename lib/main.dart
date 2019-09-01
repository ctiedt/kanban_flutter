import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

import 'boards.dart';

void main() {
  //This is required to make the app run on desktop platforms
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanban',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Tasks can be in one of three categories
  /// Each category is a list of strings
  final _tasks = <String, List<String>>{
    'Open': <String>[],
    'In Progress': <String>[],
    'Done': <String>[]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Boards(
        boards: _tasks,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _createTask,
      ),
    );
  }

  /// This is the dialog for creating a new task.
  /// Once the task has been created, it will be added
  /// to the "Open" category.
  void _createTask() async {
    var controller = TextEditingController();
    String task = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text('Create a task'),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller,
                          minLines: 10,
                          maxLines: 15,
                          decoration: InputDecoration(
                            hintText: 'Describe your task',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.check),
                        onPressed: () =>
                            Navigator.pop(context, controller.value.text),
                      ),
                    ))) ??
        '';
    if (task.isNotEmpty) _tasks['Open'].add(task);
  }
}
