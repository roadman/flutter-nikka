// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'todo_dialog.dart';
import 'todo.dart';

class TodoTable extends StatefulWidget {
  static const String routeName = '/material/data-table';
  
  TodoTable() {
    initDatabase();
  }
  
  void initDatabase() async {

  }

  @override
  _DataTableDemoState createState() => new _DataTableDemoState();
}

class _DataTableDemoState extends State<TodoTable> {
  List<Todo> _todos = <Todo>[];
  Database _db;

  _DataTableDemoState() {
  }
  
  Future<int> loadTodos(bool isCreate) async {
    if(_db == null) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = documentsDirectory.path + "/nikka.db";
      print(path);
      _db = await openDatabase(path);
    }
    if(isCreate) {
      await _db.execute("CREATE TABLE  IF NOT EXISTS Todo (id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)");
    }
    List<Map> list = await _db.rawQuery('SELECT * FROM Todo');
    _todos = <Todo>[];
    list.forEach(((todo) {
      _todos.add( 
        new Todo(todo['id'], false, todo['name'], todo['priority'])
      );
    }));
    return _todos.length;
  }
  
  void _addRow() async {
    int idx = await _db.rawInsert(
      'INSERT INTO Todo(name, priority) VALUES(?, ?)',
      ["todo", 1]);
    print(idx);
    loadTodos(false);
    setState(() {});
  }

  void _deleteRow(Todo todo) async {
  // Delete a record
    int count = await _db.rawDelete('DELETE FROM Todo WHERE id = ?', [todo.id]);
    assert(count == 1);
    loadTodos(false);
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
    loadTodos(true);
    print('widget build: todo.length -> ' + _todos.length.toString());
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
