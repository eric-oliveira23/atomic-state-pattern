import 'package:asp/asp.dart';
import 'package:supertodo/app/interactor/models/todo_model.dart';

final allTodosState = Atom<List<TodoModel>>([]);
final completeTodosState = Atom<List<TodoModel>>([]);
final incompleteTodosState = Atom<List<TodoModel>>([]);
