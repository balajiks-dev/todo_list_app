import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:todo_list_app/config/dependency_injection/injection_container.dart';
import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:todo_list_app/modules/home/data/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_event.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_state.dart';


@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetTaskList>(_onGetTaskList);
  }

  Future<void> _onGetTaskList(
    GetTaskList event,
    Emitter<HomeState> emit,
  ) async {
    emit(ShowProgressBar());
    List<TaskModel> tasks = await getIt<HomeRepository>().getTaskList();
    int completedTaskCount = 0;
    int pendingTaskCount = 0;
    for (var element in tasks) {
      if (element.status != null && element.status == 0) {
        pendingTaskCount++;
      } else {
        completedTaskCount++;
      }
    }
    emit(ShowTaskList(
      taskList: tasks,
      pendingTaskCount: pendingTaskCount,
      completedTaskCount: completedTaskCount,
    ));
  }
}
