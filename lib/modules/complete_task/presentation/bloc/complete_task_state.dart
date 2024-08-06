import 'package:flutter/material.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';

@immutable
abstract class CompleteTaskState {}

class AddTaskInitial extends CompleteTaskState {}

class TaskAddedState extends CompleteTaskState {}

class ShowProgressBar extends CompleteTaskState {}

class MarkedAsCompletedSuccess extends CompleteTaskState {
  final List<TaskModel> taskList;
  final int completedTaskCount;
  final int pendingTaskCount;

  MarkedAsCompletedSuccess({required this.taskList, required this.completedTaskCount, required this.pendingTaskCount});
}