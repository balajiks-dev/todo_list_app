class TaskModel {
  int? id;
  String? title;
  DateTime? date;
  int? status; // 0 - Pending, 1 - Completed
  String? description;

  TaskModel({this.id, this.title, this.date, this.status, this.description});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      status: json['status'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date?.toIso8601String(),
      'status': status,
      'description': description,
    };
  }
}