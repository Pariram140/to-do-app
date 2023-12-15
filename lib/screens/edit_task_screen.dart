import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task initialTask;
  final Function(Task) onTaskUpdated;

  EditTaskScreen({required this.initialTask, required this.onTaskUpdated});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController priorityController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing task values
    titleController = TextEditingController(text: widget.initialTask.title);
    priorityController = TextEditingController(text: widget.initialTask.priority ?? '');
    categoryController = TextEditingController(text: widget.initialTask.category ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(
                labelText: 'Priority (e.g., high, medium, low)',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update the task with the edited values
                Task updatedTask = Task(
                  title: titleController.text,
                  dueDate: widget.initialTask.dueDate,
                  priority: priorityController.text,
                  category: categoryController.text,
                  isCompleted: widget.initialTask.isCompleted,
                );

                // Callback to notify the parent screen about the updated task
                widget.onTaskUpdated(updatedTask);

                // Close the edit task screen
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
