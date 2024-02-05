import 'package:supertodo/app/interactor/models/todo_model.dart';

abstract class TodoRepository {
  Future<List<TodoModel>> getAll();
  Future<List<TodoModel>> insert(TodoModel model);
  Future<List<TodoModel>> update(TodoModel model);
  Future<bool> delete(int id);
}
