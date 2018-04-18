// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Todo {
  Todo(this.name, this.priority);
  final String name;
  final int priority;

  bool selected = false;
}

class TodoDataSource extends DataTableSource {
  final List<Todo> _todos = <Todo>[
    new Todo('Sample todo', 0)
  ];

  void _sort<T>(Comparable<T> getField(Todo d), bool ascending) {
    _todos.sort((Todo a, Todo b) {
      if (!ascending) {
        final Todo c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _todos.length)
      return null;
    final Todo todo = _todos[index];
    return new DataRow.byIndex(
      index: index,
      selected: todo.selected,
      onSelectChanged: (bool value) {
        if (todo.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          todo.selected = value;
          notifyListeners();
        }
      },
      cells: <DataCell>[
        new DataCell(new Text('${todo.name}')),
        new DataCell(new Text('${todo.priority}')),
      ]
    );
  }

  @override
  int get rowCount => _todos.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    for (Todo todo in _todos)
      todo.selected = checked;
    _selectedCount = checked ? _todos.length : 0;
    notifyListeners();
  }
}

class TodoTable extends StatefulWidget {
  static const String routeName = '/material/data-table';

  @override
  _DataTableDemoState createState() => new _DataTableDemoState();
}

class _DataTableDemoState extends State<TodoTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  final TodoDataSource _todosDataSource = new TodoDataSource();

  void _sort<T>(Comparable<T> getField(Todo d), int columnIndex, bool ascending) {
    _todosDataSource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Todo list')),
      body: new ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new PaginatedDataTable(
            header: const Text('Todo'),
            rowsPerPage: _rowsPerPage,
            onRowsPerPageChanged: (int value) { setState(() { _rowsPerPage = value; }); },
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            onSelectAll: _todosDataSource._selectAll,
            columns: <DataColumn>[
              new DataColumn(
                label: const Text('Todo (100g serving)'),
                onSort: (int columnIndex, bool ascending) => _sort<String>((Todo d) => d.name, columnIndex, ascending)
              ),
              new DataColumn(
                label: const Text('Priority'),
                tooltip: 'todo priority.',
                numeric: true,
                onSort: (int columnIndex, bool ascending) => _sort<num>((Todo d) => d.priority, columnIndex, ascending)
              ),
            ],
            source: _todosDataSource
          )
        ]
      )
    );
  }
}
