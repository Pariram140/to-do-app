import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/task_service.dart';

void main() {
  group('TaskService Tests', () {
    test('Add Task', () {
      TaskService taskService = TaskService();
      Task newTask = Task(title: 'Test Task', isCompleted: true, dueDate: DateTime.now(), priority: 'high', category: 'test');

      taskService.addTask(newTask);

      expect(taskService.tasks.length, 1);
      expect(taskService.tasks[0], newTask);
    });

    test('Update Task', () {
      TaskService taskService = TaskService();
      Task initialTask = Task(title: 'Test Task', isCompleted: true, dueDate: DateTime.now(), priority: 'high', category: 'test');
      taskService.addTask(initialTask);

      Task updatedTask = Task(title: 'updated Task', isCompleted: true, dueDate: DateTime.now(), priority: 'high', category: 'test');
      taskService.updateTask(0, updatedTask);

      expect(taskService.tasks.length, 1);
      expect(taskService.tasks[0], updatedTask);
    });

    test('Delete Task', () {
      TaskService taskService = TaskService();
      Task taskToDelete = Task(title: 'delete Task', isCompleted: true, dueDate: DateTime.now(), priority: 'high', category: 'test');
      taskService.addTask(taskToDelete);

      taskService.deleteTask(0);

      expect(taskService.tasks.length, 0);
    });
  });
}
