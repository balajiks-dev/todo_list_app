import 'package:todo_list_app/modules/home/data/model/task_model.dart';

abstract class AddTaskEvent {}

class AddTaskTapped extends AddTaskEvent{
  final TaskModel taskModel;

  AddTaskTapped({required this.taskModel});
}