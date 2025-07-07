# 🧠 TidyMind

TidyMind is a clean, task-oriented Flutter app that helps users organize daily responsibilities while keeping mental clarity in focus. Users can add, repeat, check off, and delete tasks, as well as toggle smart suggestions for a personalized experience. All data is securely synced through Firebase.

---

## ✨ Features

- ✅ **User Authentication** via Firebase (Login & Signup)
- 📅 **Task Management**: Add tasks with due dates, optional descriptions, and completion toggles
- 🔁 **Smart Repetition**: Repeat tasks every X days, for Y times
- ☁️ **Cloud Sync**: Tasks stored per user using Firestore
- 🌓 **Theme Switching**: Light and dark mode toggle
- 🧠 **Smart Suggestions**: Optional contextual task suggestions (not implemented yet)
- 🧹 **Bulk Delete**: Clear all tasks from Firebase in one tap

---

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/YOUR_USERNAME/TidyMind-Final.git
cd TidyMind-CS4750

lib/
├── main.dart            # App entry point & theme setup
├── authpage.dart        # Firebase login/signup UI
├── homepage.dart        # Task dashboard (add, delete, filter)
├── addnewtask.dart      # Create task with repeat options
├── settings.dart        # Toggle theme & clear tasks
├── task.dart            # Task model (to/from JSON)
├── theme.dart           # ThemeNotifier for light/dark mode
