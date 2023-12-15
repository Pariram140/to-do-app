import 'package:todo_app/models/task.dart';

class TaskService {
  List<Task> tasks = [];

  void addTask(Task task) {
    tasks.add(task);
  }

  void updateTask(int index, Task updatedTask) {
    tasks[index] = updatedTask;
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
  }
}
