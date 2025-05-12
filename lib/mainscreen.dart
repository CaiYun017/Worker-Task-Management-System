import 'package:flutter/material.dart';
import 'package:wtms/model/worker.dart';
import 'package:wtms/loginscreen.dart';
import 'package:wtms/registerscreen.dart';

class MainScreen extends StatefulWidget {
  final Worker worker;
  const MainScreen({super.key, required this.worker});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen"),
        backgroundColor: Colors.amber.shade900,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.login))
        ],
      ),
      body: Center(
        child: Text(
          "Welcome ${widget.worker.full_name}",
          style: TextStyle(fontSize: 24, color: Colors.purple.shade600),
        ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  },
  backgroundColor: Colors.amber.shade900,
  child: const Icon(Icons.add),
),
    );
  }
}