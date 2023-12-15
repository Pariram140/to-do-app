import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class TaskCreationScreen extends StatefulWidget {
  final Function(Task) onTaskCreated;

  TaskCreationScreen({required this.onTaskCreated});

  @override
  _TaskCreationScreenState createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  TextEditingController titleController = TextEditingController();
  DateTime selectedDueDate = DateTime.now();
  TextEditingController priorityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
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
            Row(
              children: [
                Text('Due Date:'),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () => _selectDueDate(context),
                  child: Text(
                    "${selectedDueDate.toLocal()}".split(' ')[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
                Task newTask = Task(
                  title: titleController.text,
                  dueDate: selectedDueDate,
                  priority: priorityController.text,
                  category: categoryController.text,
                  isCompleted: false,
                );

                widget.onTaskCreated(newTask);
                Navigator.pop(context);
              },
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDueDate)
      setState(() {
        selectedDueDate = picked;
      });
  }
}
