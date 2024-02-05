import 'dart:convert';

import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 1)
class TodoModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isComplete;

  TodoModel({
    required this.id,
    required this.title,
    required this.isComplete,
  });

  TodoModel copyWith({
    int? id,
    String? title,
    bool? isComplete,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'isComplete': isComplete,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int,
      title: map['title'] as String,
      isComplete: map['isComplete'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TodoModel(id: $id, title: $title, isComplete: $isComplete)';

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.isComplete == isComplete;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isComplete.hashCode;
}
