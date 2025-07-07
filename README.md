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
cd TidyMind-Final

lib/
├── main.dart            # App entry point & theme setup
├── authpage.dart        # Firebase login/signup UI
├── homepage.dart        # Task dashboard (add, delete, filter)
├── addnewtask.dart      # Create task with repeat options
├── settings.dart        # Toggle theme & clear tasks
├── task.dart            # Task model (to/from JSON)
├── theme.dart           # ThemeNotifier for light/dark mode

<img src="https://github.com/callistabudiman16/TidyMind-Final/blob/main/ss/Screenshot%202025-07-06%20230731.png?raw=true" alt="Home">


![Screenshot 2025-07-06 230747](https://github.com/user-attachments/assets/174cf26f-63c8-42fb-92e3-10c5a82d03e4)
![Screenshot 2025-07-06 230846](https://github.com/user-attachments/assets/a2581a3e-3325-4223-b160-e9d97680f780)
![Screenshot 2025-07-06 230855](https://github.com/user-attachments/assets/cbe09697-9696-4821-90b0-afb84c1fc77c)



**### Future Implementation**

🧠 Smart Features
When user adds a chore like “cook,” the app may suggest:
“How about trying oatmeal tomorrow morning?”

If user sets “repeat every 7 days,” the app generates upcoming instances.



👩‍💻 Created by
Natasha Callista Budiman
📧 callistabudiman16@github.com
📍 Cal Poly Pomona | Summer 2025

“Clear your space. Calm your mind.” 🌱


