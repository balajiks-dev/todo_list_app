import 'package:flutter/material.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';

@immutable
abstract class CompleteTaskEvent {}

class MarkAsCompleteTask extends CompleteTaskEvent {
  final List<TaskModel> taskList;
  final TaskModel markedCompletedTask;

  MarkAsCompleteTask({required this.taskList, required this.markedCompletedTask});
}