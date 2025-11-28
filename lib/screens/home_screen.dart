import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/components/todolist_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  List toDoList = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      setState(() {
        toDoList = List.from(jsonDecode(tasksString));
      });
    }
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(toDoList));
  }

  void saveNewTask() {
    if (_controller.text.isEmpty) return;
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
    saveTasks();
  }

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar replacement
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      'Task Manager',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade900,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.checklist_rounded,
                      color: Colors.deepPurple.shade700,
                      size: 28,
                    ),
                  ],
                ),
              ),
              // Task list
              Expanded(
                child: toDoList.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks yet!',
                          style: TextStyle(
                            color: Colors.deepPurple.shade700,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: toDoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TodolistIcon(
                            taskName: toDoList[index][0],
                            value: toDoList[index][1],
                            onChanged: (newValue) {
                              checkBoxChanged(index);
                            },
                            onDelete: () {
                              deleteTask(index);
                            },
                          );
                        },
                      ),
              ),
              // Add task input bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Add a new task',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: saveNewTask,
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(14),
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
