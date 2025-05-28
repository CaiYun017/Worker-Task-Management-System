import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/mainscreen.dart'; 
import 'submit_work_screen.dart';
import 'package:wtms/model/worker.dart';

class TaskListScreen extends StatefulWidget {
  final int workerId;
  final String workerName;

  const TaskListScreen({
    super.key,
    required this.workerId,
    required this.workerName, required String name,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://10.133.132.76/wtms/get_works.php"),
        body: {
          "worker_id": widget.workerId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            tasks = List<Map<String, dynamic>>.from(jsonData['data']);
            isLoading = false;
          });
        } else {
          setState(() {
            tasks = [];
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonData['message'] ?? 'No tasks found')),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load tasks')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.play_circle;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks - ${widget.workerName}'),
        backgroundColor: Colors.amber.shade900,
        actions: [
          IconButton(
            onPressed: () {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
                                    worker: Worker(
                                      id: 0,
                                      full_name: "Guest",
                                      email: "",
                                      phone: "",
                                      address: "", 
                                      password: '',
                                    ),
                                  ),
            ),
        );
         },
          icon: const Icon(Icons.logout),
        tooltip: 'Logout',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No tasks assigned',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadTasks,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Task Title and Status
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      task['title'] ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(task['status'] ?? 'pending'),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          getStatusIcon(task['status'] ?? 'pending'),
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          (task['status'] ?? 'pending').toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Task Description
                              Text(
                                task['description'] ?? 'No description',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Dates
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Assigned: ${task['date_assigned'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.schedule, size: 16, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Due: ${task['due_date'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Submit Button
                              if (task['status'] == 'pending')
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubmitWorkScreen(
                                            workId: int.parse(task['id'].toString()),
                                            workerId: widget.workerId,
                                            taskTitle: task['title'] ?? 'No Title',
                                          ),
                                        ),
                                      );
                                      
                                      // Refresh the list if submission was successful
                                      if (result == true) {
                                        loadTasks();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber.shade900,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Submit Work'),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}