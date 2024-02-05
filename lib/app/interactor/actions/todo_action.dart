import 'package:supertodo/app/injector.dart';
import 'package:supertodo/app/interactor/atoms/todo_state.dart';
import 'package:supertodo/app/interactor/models/todo_model.dart';
import 'package:supertodo/app/interactor/repositories/todo_repository.dart';

Future<void> fetchTodos() async {
  final repository = injector.get<TodoRepository>();
  allTodosState.value = await repository.getAll();

  incompleteTodosState.value.clear();
  completeTodosState.value.clear();

  for (var element in allTodosState.value) {
    if (element.isComplete) {
      if (!completeTodosState.value.contains(element)) {
        completeTodosState.value.add(element);
      }
    } else {
      if (!incompleteTodosState.value.contains(element)) {
        incompleteTodosState.value.add(element);
      }
    }
  }

  incompleteTodosState();
  completeTodosState();
}

Future<void> putTodo(TodoModel todo) async {
  final repository = injector.get<TodoRepository>();

  if (todo.id == -1) {
    await repository.insert(todo);
  } else {
    await repository.update(todo);
  }

  await fetchTodos();
}

Future<void> deleteTodo(int id) async {
  final repository = injector.get<TodoRepository>();
  await repository.delete(id);
  await fetchTodos();
}
