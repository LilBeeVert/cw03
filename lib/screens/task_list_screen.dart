import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();
  final TaskService _service = TaskService();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _service.addTask(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: "New task"),
                  ),
                ),
                ElevatedButton(onPressed: _addTask, child: const Text("Add"))
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _service.streamTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final tasks = snapshot.data ?? [];

                if (tasks.isEmpty) {
                  return const Center(child: Text("No tasks yet"));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, i) {
                    return TaskTile(task: tasks[i], service: _service);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
