import 'package:flutter/material.dart';
import 'task_list_screen.dart';
import 'submission_history_screen.dart';
import 'profilescreen.dart'; 

class HomeScreen extends StatefulWidget {
  final int workerId;
  final String workerName;

  const HomeScreen({
    super.key,
    required this.workerId,
    required this.workerName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    print("👀 workerId for ProfileScreen: ${widget.workerId}"); // 👈 Debug 打印


    _screens = [
      TaskListScreen(workerId: widget.workerId, workerName: widget.workerName),
      SubmissionHistoryScreen(workerId: widget.workerId), 
      ProfileScreen(workerId: widget.workerId), 
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
