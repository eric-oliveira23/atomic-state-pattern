import 'package:auto_injector/auto_injector.dart';
import 'package:supertodo/app/data/repositories/hive_todo_repositories.dart';
import 'package:supertodo/app/interactor/repositories/todo_repository.dart';

final injector = AutoInjector();

void registerInstances() {
  injector.add<TodoRepository>(HiveTodoRepository.new);
}
