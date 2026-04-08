import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final TaskService service;

  const TaskTile({super.key, required this.task, required this.service});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool expanded = false;
  final TextEditingController subController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.task.title,
              style: TextStyle(
                decoration: widget.task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            leading: Checkbox(
              value: widget.task.isCompleted,
              onChanged: (_) => widget.service.toggleTask(widget.task),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => widget.service.deleteTask(widget.task.id),
            ),
            onTap: () {
              setState(() => expanded = !expanded);
            },
          ),

          if (expanded) ...[
            Column(
              children: widget.task.subtasks.asMap().entries.map((entry) {
                return ListTile(
                  title: Text(entry.value['title']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        widget.service.deleteSubtask(widget.task, entry.key),
                  ),
                );
              }).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: subController,
                    decoration:
                        const InputDecoration(hintText: "Add subtask"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    widget.service.addSubtask(
                        widget.task, subController.text);
                    subController.clear();
                  },
                )
              ],
            )
          ]
        ],
      ),
    );
  }
}