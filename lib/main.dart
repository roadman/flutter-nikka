import 'package:flutter/material.dart';
import 'todo_table.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new TodoTable(),
    );
  }
}
