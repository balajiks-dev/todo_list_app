import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_event.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_state.dart';
import 'package:todo_list_app/modules/home/data/repository/home_repository.dart';
import 'package:todo_list_app/modules/task_filter/bloc/task_filter_event.dart';
import 'package:todo_list_app/modules/task_filter/bloc/task_filter_state.dart';

@injectable
class TaskFilterBloc extends Bloc<TaskFilterEvent, TaskFilterState> {
  TaskFilterBloc() : super(TaskFilterInitial()) {
    on<SelectTaskStatus>(_onSelectTaskStatus);
  }

  Future<void> _onSelectTaskStatus(
      SelectTaskStatus event,
      Emitter<TaskFilterState> emit,
      ) async {
     emit(UpdateTaskStatus(status: event.status));
  }
}
