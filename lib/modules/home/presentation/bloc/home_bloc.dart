import 'dart:convert';

import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/core/network/meta.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:todo_list_app/modules/splash/data/model/failure_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static final List<TaskModel> _taskModel = [];

  HomeBloc() : super(HomeInitial()) {
    on<GetTaskList>(_onGetTaskList);
  }

  Future<void> _onGetTaskList(
    GetTaskList event,
    Emitter<HomeState> emit,
  ) async {
    emit(ShowProgressBar());
    int completedTaskCount = 0;
    int pendingTaskCount = 0;
    _taskModel.forEach((element) {
      if (element.status != null && element.status == 0) {
        pendingTaskCount++;
      } else {
        completedTaskCount++;
      }
    });
    emit(ShowTaskList(
      taskList: _taskModel,
      pendingTaskCount: pendingTaskCount,
      completedTaskCount: completedTaskCount,
    ));
  }
}
