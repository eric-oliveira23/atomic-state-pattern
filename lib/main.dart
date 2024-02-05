import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supertodo/app/app.dart';
import 'package:supertodo/app/injector.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supertodo/app/interactor/models/todo_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());

  registerInstances();
  runApp(const SuperTodo());
}
