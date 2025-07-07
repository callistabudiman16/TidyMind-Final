class Task {
  final String title;
  final String? description;
  final DateTime dueDate;
  bool isCompleted;
  final String? id;

  Task({
    required this.title,
    required this.dueDate,
    this.description,
    this.isCompleted = false,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json, String id) {
    return Task(
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'] ?? false,
      id: id,
    );
  }
}
