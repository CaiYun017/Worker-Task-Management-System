# Worker Task Management System (WTMS) - Task Submission Extension

## 📌 Objective
This project extends the existing Worker Task Management System (WTMS) by enabling logged-in workers to:
- View their assigned tasks
- Submit work completion reports

## 🛠️ Functional Requirements

### 1. Task List for Workers
- After login, the worker retrieves a list of assigned tasks from the `tbl_works` database.
- Each task displays:
  - Task ID
  - Title
  - Description
  - Date Assigned
  - Due Date
  - Status (Pending, In Progress, Completed)

### 2. Work Completion Upload
- Workers can select a task and submit a work completion description.
- Submissions are stored in a new table: `tbl_submissions`.

---

## 📱 Flutter App Features

### ✅ Task List Screen
- Automatically loads tasks assigned to the currently logged-in worker.
- Displays:
  - Task title
  - Description
  - Due date
  - Status with color/icon indicators
- Includes `Logout` button for session termination.

### ✅ Submit Completion Screen
- Accessed by selecting a task with “Pending” status.
- Features:
  - Read-only Task Title
  - Input field: *“What did you complete?”*
  - Submit button to send data to backend
  - Success/failure feedback

---

## 🧑‍💻 Technologies Used

| Component   | Stack               |
|------------|---------------------|
| Frontend   | Flutter (Dart)      |
| Backend    | PHP (XAMPP)         |
| Database   | MySQL               |
| API Comm   | HTTP POST Requests  |

---

## 📂 Folder Structure

```bash
lib/
├── main.dart
├── login_screen.dart
├── register_screen.dart
├── task_list_screen.dart
├── submit_work_screen.dart
php/
├── login.php
├── register.php
├── get_works.php
├── submit_work.php
database/
├── tbl_workers.sql
├── tbl_works.sql
├── tbl_submissions.sql
