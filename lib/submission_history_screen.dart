import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/model/submission.dart';
import 'package:wtms/edit_submission_screen.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final int workerId;

  const SubmissionHistoryScreen({super.key, required this.workerId});

  @override
  State<SubmissionHistoryScreen> createState() => _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  late Future<List<Submission>> _futureSubmissions;

  @override
  void initState() {
    super.initState();
    _futureSubmissions = fetchSubmissions();
  }

  Future<List<Submission>> fetchSubmissions() async {
    final response = await http.post(
      Uri.parse("http://192.168.68.106/wtms/get_submissions.php"),
      body: {"worker_id": widget.workerId.toString()},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Submission.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load submissions");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Submission History"),
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Submission>>(
        future: _futureSubmissions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No submissions found."));
          }

          final submissions = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: submissions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final submission = submissions[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditSubmissionScreen(
                        submissionId: submission.id,
                        originalText: submission.submissionText,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.task_alt,
                          size: 36,
                          color: Colors.indigo,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                submission.taskTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Submitted on: ${submission.submittedAt}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                submission.submissionText.length > 80
                                    ? "${submission.submissionText.substring(0, 80)}..."
                                    : submission.submissionText,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
