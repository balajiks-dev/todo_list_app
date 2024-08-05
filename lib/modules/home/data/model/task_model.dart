class TaskModel {
  int? id;
  String title;
  DateTime? date;
  String? priority;
  int? status; // 0 - Pending, 1 - Completed

  TaskModel({this.id, this.title = "Untitled", this.date, this.priority, this.status});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      priority: json['priority'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date?.toIso8601String(),
      'priority': priority,
      'status': status,
    };
  }
}