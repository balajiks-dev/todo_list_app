import 'package:todo_list_app/modules/home/data/model/task_model.dart';


abstract class AddTaskState {}

class AddTaskInitial extends AddTaskState {}

class TaskAddedState extends AddTaskState {}

class ShowProgressBar extends AddTaskState {}

class TaskAddedSuccess extends AddTaskState {
  final List<TaskModel> taskList;

  TaskAddedSuccess({required this.taskList});
}

class FailureState extends AddTaskState {
  final String message;

  FailureState({required this.message});
}