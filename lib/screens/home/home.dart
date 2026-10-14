import 'package:flutter/material.dart';
import 'package:trying_flutter/utils/todo_list.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List toDoList = [
    ['Task 1', false],
    ['Task 2', false],
    ['Task 3', false],
  ];

  void checkboxChanged(int index){
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Todo Application'),
        backgroundColor: Colors.blue.shade300,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(itemCount: toDoList.length, itemBuilder: (BuildContext context, index){
        return Todolist(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
          onChanged: (value) => checkboxChanged(index),
        );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
      ),
    );
  }
}