// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'todo_dialog.dart';
import 'todo.dart';

class TodoTable extends StatefulWidget {
  static const String routeName = '/material/data-table';
  
  TodoTable() {
    initDatabase();
  }
  
  void initDatabase() async {
    // Get a location using path_provider
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, "nikka.db");
    // await openDatabase(path, version: 1,
    //     onCreate: (Database db, int version) async {
    //   // When creating the db, create the table
    //   await db.execute("CREATE TABLE Todo (id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)");
    // });
  }

  @override
  _DataTableDemoState createState() => new _DataTableDemoState();
}

class _DataTableDemoState extends State<TodoTable> {
  
  final List<Todo> _todos = <Todo>[
  ];

  void _addRow() {
    _todos.add(
      new Todo(false, 'todo', 1)
    );
    setState(() {});
  }

  void _deleteRow(Todo todo) {
    _todos.remove(todo);
    setState(() {});
  }
  
  void _upPriority(Todo todo) {
    todo.upPriority();
    setState(() {});
  }
  
  void _downPriority(Todo todo) {
    todo.downPriority();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Todo list')),
      body: new ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Row(
            children: <Widget>[
              new Checkbox(
                value: _todos[index].selected,
                onChanged: (bool newValue) {
                  _todos[index].selected = newValue;
                  setState(() {});
                }
              ),
              new Expanded(
                child: new FlatButton(
                  child: new Text(_todos[index].name),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
                      builder: (BuildContext context) => new TodoDialog(_todos[index]),
                      fullscreenDialog: true,
                    ));
                  }
                )
              ),
              new Expanded(
                child: new Text(_todos[index].priority.toString()),
              ),
              new IconButton(
                icon: const Icon(
                  Icons.thumb_up,
                  semanticLabel: 'Priority up',
                ),
                onPressed: () => _upPriority(_todos[index])
              ),
              new IconButton(
                icon: const Icon(
                  Icons.thumb_down,
                  semanticLabel: 'Priority down',
                ),
                onPressed: () => _downPriority(_todos[index])
              ),
              new IconButton(
                icon: const Icon(
                  Icons.delete,
                  semanticLabel: 'Delete',
                ),
                onPressed: () => _deleteRow(_todos[index])
                //color: iconButtonToggle ? Theme.of(context).primaryColor : null,
              )
            ],
          );
        }
      ),
      floatingActionButton: new FloatingActionButton(	
        onPressed: _addRow,
        tooltip: 'Increment',	
        child: new Icon(Icons.add),	
      )
    );
  }
}
