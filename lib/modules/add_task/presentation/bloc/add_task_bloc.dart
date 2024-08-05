import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_event.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_state.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:todo_list_app/modules/home/data/repository/home_repository.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  AddTaskBloc() : super(AddTaskInitial()) {
    on<AddTaskTapped>(_onAddTaskTappedEvent);
  }

  Future<void> _onAddTaskTappedEvent(
    AddTaskTapped event,
    Emitter<AddTaskState> emit,
  ) async {
    emit(ShowProgressBar());
    List<TaskModel> taskList = [
      TaskModel(
          title: "Same",
          id: 323,
          date: DateTime.now(),
          priority: "LOW",
          status: 0),
      TaskModel(
          title: "Different",
          id: 44,
          date: DateTime.now(),
          priority: "HIGH",
          status: 1),
    ];
    bool isSaved = await HomeRepository().saveTaskList(taskList);

    print("The Task List is Saved successfully ----> $isSaved");

    List<TaskModel> tasks = await HomeRepository().getTaskList();

    print("The Task List is retrieved successfully ----> ${tasks.toString()}");

    if(isSaved){
      emit(TaskAddedSuccess());
    }
  }
}
