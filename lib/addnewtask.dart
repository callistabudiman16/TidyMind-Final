import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int repeatDays = 1;
  int repeatCount = 1;
  DateTime lastDone = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3C8B8),
        title: const Text('Add Task', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF5EFE6),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Task Title", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Description (optional)", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Repeat for X (days)", style: TextStyle(fontWeight: FontWeight.bold)),
              NumberPicker(
                value: repeatCount,
                minValue: 0,
                maxValue: 30,
                onChanged: (value) => setState(() => repeatCount = value),
              ),
              const SizedBox(height: 16),

              const Text("Start on", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${lastDone.year}-${lastDone.month.toString().padLeft(2, '0')}-${lastDone.day.toString().padLeft(2, '0')}",
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB3C8B8)),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: lastDone,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          lastDone = picked;
                        });
                      }
                    },
                    child: const Text("Select Date", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty) return;

                      List<Task> repeatedTasks = [];

                      if (repeatDays == 0) { // no repetition
                        repeatedTasks.add(
                          Task(
                            title: _titleController.text.trim(),
                            description: _descriptionController.text.trim(),
                            dueDate: lastDone,
                          ),
                        );
                      } else {
                        for (int i = 0; i < repeatCount; i++) {
                          repeatedTasks.add(
                            Task(
                              title: _titleController.text.trim(),
                              description: _descriptionController.text.trim(),
                              dueDate: lastDone.add(Duration(days: repeatDays * i)),
                            ),
                          );
                        }
                      }

                      Navigator.pop(context, repeatedTasks);


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB3C8B8),
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.black)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
