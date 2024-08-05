part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class ShowProgressBar extends HomeState {}

class HideProgressBar extends HomeState {}

class ShowTaskList extends HomeState {
  final List<TaskModel> taskList;
  final int completedTaskCount;
  final int pendingTaskCount;

  ShowTaskList({required this.taskList, required this.completedTaskCount, required this.pendingTaskCount});
}

class FailureState extends HomeState with EquatableMixin {
  final String errorMessage;

  FailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage, identityHashCode(this)];
}
