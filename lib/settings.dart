import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool smartSuggestionsEnabled = true;
  bool darkModeEnabled = false;

  void confirmClearAllTasks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text('Are you sure you want to delete all tasks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog first

              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User not logged in.')),
                );
                return;
              }

              final tasksRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('tasks');

              final snapshot = await tasksRef.get();
              for (final doc in snapshot.docs) {
                await doc.reference.delete();
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All tasks cleared!')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3C8B8),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Smart Suggestions'),
            value: smartSuggestionsEnabled,
            onChanged: (value) {
              setState(() => smartSuggestionsEnabled = value);
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: Provider.of<ThemeNotifier>(context).isDarkMode,
            onChanged: (value) {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme(value);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Tasks', style: TextStyle(color: Colors.red)),
            onTap: confirmClearAllTasks,
          ),
        ],
      ),
    );
  }
}
