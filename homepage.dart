import 'package:flutter/material.dart';
import 'addnewtask.dart';
import 'task.dart';
import 'settings.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2018),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<Task> allTasks = [];

  @override
  void initState() {
    super.initState();
    loadFirestoreTasks();
  }

  @override
  Widget build(BuildContext context) {

    final String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());


    List<Task> filteredTasks = allTasks.where((task) {
      return task.dueDate.year == selectedDate.year &&
          task.dueDate.month == selectedDate.month &&
          task.dueDate.day == selectedDate.day;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3C8B8),
        title: Text(
          'TidyMind',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(

          children: [
            GestureDetector(
              onTap: pickDate,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(selectedDate),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const Icon(Icons.calendar_today, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Due Today',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...filteredTasks.map((task) => buildTaskTile(task)),

            const SizedBox(height: 24),
            const Text(
              'Suggested Task',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8CFCB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'It\'s been a while since you cooked. How about trying oatmeal tomorrow morning?',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB3C8B8),
        onPressed: () async {
          final List<Task>? newTasks = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );

          if (newTasks != null) {
            final uid = FirebaseAuth.instance.currentUser?.uid;
            if (uid == null) return;

            for (final task in newTasks) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('tasks')
                  .add(task.toJson());
            }

            loadFirestoreTasks(); // refresh UI
          }
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }


  Widget buildTaskTile(Task task) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: const Text('Mark as Complete'),
                    onTap: () async {
                      setState(() {
                        task.isCompleted = true;
                      });

                      final uid = FirebaseAuth.instance.currentUser?.uid;
                      if (uid != null && task.id != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('tasks')
                            .doc(task.id)
                            .update({'isCompleted': task.isCompleted});

                        Navigator.pop(context);
                      }
                    }
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Delete Task', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      confirmDelete(task);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                task.isCompleted = !task.isCompleted; // ✅ Tap to toggle
              });
            },
          ),
        ),
      ),
    );
  }

  void confirmDelete(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null && task.id != null) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('tasks')
                    .doc(task.id)
                    .delete();
              }

              setState(() {
                allTasks.removeWhere((t) => t.id == task.id);
              });

              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }



  Future<void> loadFirestoreTasks() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('dueDate')
        .get();

    setState(() {
      allTasks = snapshot.docs
          .map((doc) => Task.fromJson(doc.data(), doc.id))
          .toList();
    });
  }


}

