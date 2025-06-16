# 🛠️ Worker Task Management System (WTMS)

A mobile app built using **Flutter**, **PHP**, and **MySQL**, designed for task management between employers and workers. Workers can register, log in, view assigned tasks, submit work, and update their profiles.

---

## 📱 Features

- ✅ Worker registration and login
- ✅ View assigned tasks with status indicators (Pending, In Progress, Completed)
- ✅ Submit work with remarks
- ✅ Edit previously submitted work
- ✅ Update worker profile (except worker ID)
- ✅ Auto login using SharedPreferences
- ✅ Logout functionality

---

## 💻 Tech Stack

| Layer      | Technology         |
|------------|--------------------|
| Frontend   | Flutter             |
| Backend    | PHP (REST API)      |
| Database   | MySQL (phpMyAdmin)  |
| Server     | XAMPP (localhost)   |

---

## 📁 Project Structure
/wtms
├── lib/
│ ├── model/ # Submission and Worker models
│ ├── screens/ # Flutter UI screens
│ ├── mainscreen.dart
│ └── myconfig.dart # Config for API base URL
├── php/ # PHP backend files
│ ├── register_worker.php
│ ├── login_worker.php
│ ├── get_works.php
│ ├── submit_work.php
│ ├── get_submissions.php
│ ├── edit_submissions.php
│ └── update_profile.php
├── assets/ # Images and icons
└── README.md

## ⚙️ Setup Guide

### 1. Flutter App Setup

```bash
git clone https://github.com/caiyun017/wtms.git
cd wtms
flutter pub get
flutter run

Update your API base URL in myconfig.dart:

dart
Copy
Edit
class MyConfig {
static const String myurl = "http://192.168.68.106/wtms/"; 
}
Make sure your device/emulator and your computer are connected to the same network.

✅ PHP & MySQL Setup (Using XAMPP)
Install XAMPP
Start Apache & MySQL
Import the wtms.sql file to phpMyAdmin
Copy all PHP files into:
makefile
Copy
Edit
C:\xampp\htdocs\wtms\
🗃️ Database Structure
Table: workers
Field	Type
worker_id	INT (PK)
full_name	VARCHAR
email	VARCHAR
password	VARCHAR
phone	VARCHAR
address	TEXT
image_url	TEXT

Table: tbl_works
Field	Type
id	INT (PK)
worker_id	INT (FK)
title	VARCHAR
description	TEXT
date_assigned	DATE
due_date	DATE
status	VARCHAR

Table: tbl_submissions
Field	Type
id	INT (PK)
work_id	INT (FK)
remarks	TEXT
submitted_on	DATETIME

👩‍💻 Author
Name: [TAN CAI YUN 297991]

University: Universiti Utara Malaysia (UUM)

Program: Bachelor of Information Technology (Software Engineering)

Email: tancaiyun123@gmail.com

📄 License
This project is created for educational purposes. You are welcome to fork, use, and adapt it for your own learning.