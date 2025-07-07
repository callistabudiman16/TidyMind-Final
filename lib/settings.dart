import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool smartSuggestionsEnabled = true;
  bool darkModeEnabled = false;

  void _confirmClearAllTasks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text('Are you sure you want to delete all tasks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement actual clear logic
              Navigator.pop(context); // Close dialog
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
              // TODO: Save to SharedPreferences
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
            onTap: _confirmClearAllTasks,
          ),
        ],
      ),
    );
  }
}
