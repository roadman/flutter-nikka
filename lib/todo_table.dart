// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class Todo {
  Todo(this.selected, this.name, this.priority);
  String name;
  int priority;
  bool selected;
}

class TodoTable extends StatefulWidget {
  static const String routeName = '/material/data-table';

  @override
  _DataTableDemoState createState() => new _DataTableDemoState();
}

class _DataTableDemoState extends State<TodoTable> {
  
  final List<Todo> _todos = <Todo>[
    new Todo(false, 'Sample todo', 0)
  ];

  void _addRow() {
    _todos.add(
      new Todo(false, 'todo', 0)
    );
    setState(() {});
  }

  void _deleteRow(Todo todo) {
    _todos.remove(todo);
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
                child: new Text(_todos[index].name)
              ),
              new IconButton(
                icon: const Icon(
                  Icons.thumb_up,
                  semanticLabel: 'Priority up',
                ),
                onPressed: null,
              ),
              new IconButton(
                icon: const Icon(
                  Icons.thumb_down,
                  semanticLabel: 'Priority down',
                ),
                onPressed: null,
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
