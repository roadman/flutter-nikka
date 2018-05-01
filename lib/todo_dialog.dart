// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

// This demo is based on
// https://material.google.com/components/dialogs.html#dialogs-full-screen-dialogs

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class TodoDialog extends StatefulWidget {
  String _eventName;

  TodoDialog(String eventName) {
    this._eventName = eventName;
  }
  @override
  TodoDialogState createState() => new TodoDialogState(_eventName);
}

class TodoDialogState extends State<TodoDialog> {
  bool _saveNeeded = false;
  bool _hasName = false;
  String _eventName;
  
  TodoDialogState(String eventName) {
    this._eventName = eventName;
    this._hasName = true;
  }

  Future<bool> _onWillPop() async {
    _saveNeeded = _hasName || _saveNeeded;
    if (!_saveNeeded)
      return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new Text(
            'Discard new event?',
            style: dialogTextStyle
          ),
          actions: <Widget>[
            new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(false); // Pops the confirmation dialog but not the page.
              }
            ),
            new FlatButton(
              child: const Text('DISCARD'),
              onPressed: () {
                Navigator.of(context).pop(true); // Returning true to _onWillPop will pop again.
              }
            )
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_hasName ? _eventName : 'Event Name TBD'),
        actions: <Widget> [
          new FlatButton(
            child: new Text('SAVE', style: theme.textTheme.body1.copyWith(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context, DismissDialogAction.save);
            }
          )
        ]
      ),
      body: new Form(
        onWillPop: _onWillPop,
        child: new ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: new TextField(
                controller: new TextEditingController(
                  text: _eventName
                ),
                decoration: const InputDecoration(
                  labelText: 'Todo title',
                  filled: true
                ),
                style: theme.textTheme.headline,
                onChanged: (String value) {
                  setState(() {
                    _hasName = value.isNotEmpty;
                    if (_hasName) {
                      _eventName = value;
                    }
                  });
                }
              )
            )
          ]
          .map((Widget child) {
            return new Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              height: 96.0,
              child: child
            );
          })
          .toList()
        )
      ),
    );
  }
}
