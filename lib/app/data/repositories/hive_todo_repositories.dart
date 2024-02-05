import 'package:hive/hive.dart';
import 'package:supertodo/app/interactor/models/todo_model.dart';
import 'package:supertodo/app/interactor/repositories/todo_repository.dart';

class HiveTodoRepository implements TodoRepository {
  final String _todoBoxKey = "todo_box_key";

  @override
  Future<bool> delete(int id) async {
    final box = await Hive.openBox<TodoModel>(_todoBoxKey);
    await box.delete(id);

    return true;
  }

  @override
  Future<List<TodoModel>> getAll() async {
    final box = await Hive.openBox<TodoModel>(_todoBoxKey);
    return box.values.toList();
  }

  @override
  Future<List<TodoModel>> insert(TodoModel model) async {
    final box = await Hive.openBox<TodoModel>(_todoBoxKey);
    await box.add(model);

    return getAll();
  }

  @override
  Future<List<TodoModel>> update(TodoModel model) async {
    final box = await Hive.openBox<TodoModel>(_todoBoxKey);
    await box.put(model.id, model);

    return getAll();
  }
}
