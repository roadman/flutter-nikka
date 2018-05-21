// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class Todo {
  Todo(this.id, this.selected, this.name, this.priority);
  
  int id;
  String name;
  int priority;
  bool selected;
  
  void upPriority() {
    if(this.isNotMaxPriority()) {
      this.priority++;
    }
  }
  void downPriority() {
    if(this.isNotMinPriority()) {
      this.priority--;
    }
  }
  bool isNotMaxPriority() {
    return this.priority < 100;
  }
  bool isNotMinPriority() {
    return this.priority > 1;
  }
}
