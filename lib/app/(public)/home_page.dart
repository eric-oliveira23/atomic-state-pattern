import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supertodo/app/core/themes/app_colors.dart';
import 'package:supertodo/app/interactor/actions/todo_action.dart';
import 'package:supertodo/app/interactor/atoms/todo_state.dart';
import 'package:supertodo/app/interactor/models/todo_model.dart';
import 'package:supertodo/app/core/util/device_verifier.dart';
import 'package:supertodo/app/core/util/hash_generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime _date = DateTime.now();
  int incompleteTasks = 0;
  int completeTasks = 0;

  @override
  void initState() {
    fetchTodos().then((value) => fetchTasksData());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RxBuilder(
      builder: (_) {
        final completeTodos = completeTodosState.value;
        final incompleteTodos = incompleteTodosState.value;

        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateFormat('EEEE').format(_date)} ${_date.day}, ${_date.year}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            DeviceVerifier.responsiveTitleFontSize(context),
                      ),
                    ),
                    Text(
                      "$incompleteTasks incomplete, $completeTasks complete.",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey5757,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      color: Color(0xFFD0D0D0),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // incomplete tasks
                      Visibility(
                        visible: incompleteTodos.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                'Incomplete',
                                style: TextStyle(
                                  color: AppColors.grey5757,
                                  fontWeight: FontWeight.bold,
                                  fontSize: DeviceVerifier.responsiveFontSize(
                                      context),
                                ),
                              ),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: incompleteTodos.length,
                              itemBuilder: (_, index) {
                                final item = incompleteTodos[index];
                                return GestureDetector(
                                  onLongPress: () => showEditTodoDialog(item),
                                  child: CheckboxListTile(
                                    side: const BorderSide(
                                        color: Color(0xFFDADADA)),
                                    checkboxShape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(item.title),
                                    value: incompleteTodos[index].isComplete,
                                    onChanged: (value) async {
                                      await putTodo(
                                        item.copyWith(
                                          isComplete: value,
                                        ),
                                      );
                                      await fetchTasksData();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // complete tasks
                      Visibility(
                        visible: completeTodos.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            'Complete',
                            style: TextStyle(
                              color: AppColors.grey5757,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  DeviceVerifier.responsiveFontSize(context),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: completeTodos.length,
                        itemBuilder: (_, index) {
                          final item = completeTodos[index];
                          return GestureDetector(
                            onLongPress: () => showEditTodoDialog(item),
                            child: CheckboxListTile(
                              side: const BorderSide(color: Color(0xFFDADADA)),
                              checkboxShape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                item.title,
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              value: completeTodos[index].isComplete,
                              onChanged: (value) async {
                                await putTodo(
                                  item.copyWith(
                                    isComplete: value,
                                  ),
                                );
                                await fetchTasksData();
                              },
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => showEditTodoDialog(),
          ),
        );
      },
    );
  }

  void showEditTodoDialog([TodoModel? todo]) {
    todo ??= TodoModel(id: -1, title: '', isComplete: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit todo"),
          content: TextFormField(
            maxLength: 60,
            initialValue: todo?.title,
            onChanged: (value) {
              todo = todo?.copyWith(title: value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (todo!.title.isEmpty) {
                  return;
                }

                Navigator.pop(context);
                putTodo(
                  todo!.copyWith(
                    id: todo!.id == -1 ? hashGenerator(todo!.title) : null,
                  ),
                );
              },
              child: const Text("Save"),
            ),
            Visibility(
              visible: todo!.id != -1,
              child: TextButton(
                onPressed: () {
                  deleteTodo(todo!.id);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchTasksData() async {
    completeTasks = completeTodosState.value.length;
    incompleteTasks = incompleteTodosState.value.length;
  }
}
