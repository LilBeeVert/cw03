import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference _tasks =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;

    await _tasks.add({
      'title': title.trim(),
      'isCompleted': false,
      'subtasks': [],
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Task>> streamTasks() {
    return _tasks.orderBy('createdAt').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Future<void> toggleTask(Task task) async {
    await _tasks.doc(task.id).update({
      'isCompleted': !task.isCompleted,
    });
  }

  Future<void> deleteTask(String id) async {
    await _tasks.doc(id).delete();
  }

  Future<void> addSubtask(Task task, String subtaskTitle) async {
    final updated = List<Map<String, dynamic>>.from(task.subtasks)
      ..add({'title': subtaskTitle, 'done': false});

    await _tasks.doc(task.id).update({'subtasks': updated});
  }

  Future<void> deleteSubtask(Task task, int index) async {
    final updated = List<Map<String, dynamic>>.from(task.subtasks)
      ..removeAt(index);

    await _tasks.doc(task.id).update({'subtasks': updated});
  }
}
