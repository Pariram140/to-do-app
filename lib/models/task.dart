class Task {
  String title;
  DateTime dueDate;
  String priority;
  String category;
  bool isCompleted;

  Task({
    required this.title,
    required this.isCompleted,
    required this.dueDate,
    required this.priority,
    required this.category,
  });
}
