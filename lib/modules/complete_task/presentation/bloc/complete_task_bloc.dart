import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_event.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_state.dart';
import 'package:todo_list_app/modules/home/data/repository/home_repository.dart';

class CompleteTaskBloc extends Bloc<CompleteTaskEvent, CompleteTaskState> {
  CompleteTaskBloc() : super(AddTaskInitial()) {
    on<MarkAsCompleteTask>(_onMarkAsCompleteTask);
  }

  Future<void> _onMarkAsCompleteTask(
      MarkAsCompleteTask event,
    Emitter<CompleteTaskState> emit,
  ) async {
    emit(ShowProgressBar());
    event.taskList.forEach((element){
      if(element == event.markedCompletedTask){
        element.status = 1;
      }
    });
    bool isSaved = await HomeRepository().saveTaskList(event.taskList);
    int completedTaskCount = 0;
    int pendingTaskCount = 0;
    for (var element in event.taskList) {
      if (element.status != null && element.status == 0) {
        pendingTaskCount++;
      } else {
        completedTaskCount++;
      }
    }
    emit(MarkedAsCompletedSuccess(
      taskList: event.taskList,
      pendingTaskCount: pendingTaskCount,
      completedTaskCount: completedTaskCount,
    ));
  }
}
