import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_event.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_state.dart';

class CompleteTaskBloc extends Bloc<CompleteTaskEvent, CompleteTaskState> {
  CompleteTaskBloc() : super(AddTaskInitial()) {
    on<MarkAsCompleteTask>(_onMarkAsCompleteTask);
  }

  Future<void> _onMarkAsCompleteTask(
      MarkAsCompleteTask event,
    Emitter<CompleteTaskState> emit,
  ) async {
    emit(ShowProgressBar());

  }
}
