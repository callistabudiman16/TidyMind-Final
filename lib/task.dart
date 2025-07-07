class Task {
  final String title;
  final DateTime dueDate;
  bool isCompleted;
  final String? id;

  Task({
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json, String id) {
    return Task(
      title: json['title'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'] ?? false,
      id: id,
    );
  }
}
