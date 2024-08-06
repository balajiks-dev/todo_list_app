
class TaskFilterEvent {}

class SelectTaskStatus extends TaskFilterEvent{
  final String status;
  SelectTaskStatus({required this.status});
}
