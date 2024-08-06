import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_event.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_state.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:todo_list_app/modules/home/data/repository/home_repository.dart';
import 'package:todo_list_app/modules/splash/data/model/failure_response_model.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  AddTaskBloc() : super(AddTaskInitial()) {
    on<AddTaskTapped>(_onAddTaskTappedEvent);
  }

  Future<void> _onAddTaskTappedEvent(
    AddTaskTapped event,
    Emitter<AddTaskState> emit,
  ) async {
    if (event.taskModel.title != null &&
        event.taskModel.title!.isNotEmpty &&
        event.taskModel.description != null &&
        event.taskModel.description!.isNotEmpty &&
        event.taskModel.date != null) {
      List<TaskModel> tasks = await HomeRepository().getTaskList();
      tasks.add(event.taskModel);
      bool isSaved = await HomeRepository().saveTaskList(tasks);
      if (isSaved) {
        emit(TaskAddedSuccess(taskList: tasks));
      }
    } else {
      String error = "";
      emit(FailureState(message: error));
    }
  }
}
