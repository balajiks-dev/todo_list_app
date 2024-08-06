class TaskFilterState {}

final class TaskFilterInitial extends TaskFilterState {}

class UpdateTaskStatus extends TaskFilterState{
  final String status;
  UpdateTaskStatus({required this.status});
}
