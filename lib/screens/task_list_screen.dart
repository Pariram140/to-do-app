import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/edit_task_screen.dart';
import 'package:todo_app/screens/task_creation_screen.dart';
import 'package:todo_app/services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService taskService = TaskService();
  int selectedTaskIndex = 0; // To keep track of the selected task index
  Offset longPressPosition = Offset.zero; // To store the long-press position

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: taskService.tasks.length,
        itemBuilder: (context, index) {
          Task task = taskService.tasks[index];
          return GestureDetector(
            onLongPressStart: (details) {
              longPressPosition = details.globalPosition;
              _showTaskOptions(context, index);
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  selectedTaskIndex = index;
                });
              },
              onExit: (_) {
                setState(() {
                  selectedTaskIndex = 0;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                color: selectedTaskIndex == index
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.transparent,
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(task.dueDate != null
                      ? 'Due on ${task.dueDate.toLocal()}'
                      : 'No due date'),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      _markTaskCompleteWithAnimation(context, index);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedTaskIndex = index;
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskCreationScreen(
                onTaskCreated: (newTask) {
                  setState(() {
                    taskService.addTask(newTask);
                  });
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _markTaskCompleteWithAnimation(BuildContext context, int index) async {
    await Scrollable.ensureVisible(
      context,
      alignment: 0.5, // Center the selected task
      duration: Duration(seconds: 1),
    );

    setState(() {
      taskService.tasks[index].isCompleted = !taskService.tasks[index].isCompleted; // added to toggle back
      taskService.updateTask(index, Task(
        title: taskService.tasks[index].title,
        dueDate: taskService.tasks[index].dueDate,
        priority: taskService.tasks[index].priority,
        category: taskService.tasks[index].category,
        isCompleted: taskService.tasks[index].isCompleted,
      ));
    });
  }

  void _showTaskOptions(BuildContext context, int index) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        longPressPosition,
        longPressPosition.translate(0, 0),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Task'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Task'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        _editTask(context, index);
      } else if (value == 'delete') {
        _deleteTask(index);
      }
    });
  }

  void _editTask(BuildContext context, int index) {
    Task initialTask = taskService.tasks[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          initialTask: initialTask,
          onTaskUpdated: (updatedTask) {
            setState(() {
              taskService.updateTask(index, updatedTask);
            });
          },
        ),
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      taskService.deleteTask(index);
    });
  }
}
