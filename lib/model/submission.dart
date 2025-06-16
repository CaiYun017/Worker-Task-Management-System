class Submission {
  final int id;
  final String submissionText;
  final String submittedAt;
  final String taskTitle;

  Submission({
    required this.id,
    required this.submissionText,
    required this.submittedAt,
    required this.taskTitle,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: int.parse(json['id'].toString()),
      submissionText: json['submission_text'],
      submittedAt: json['submitted_at'],
      taskTitle: json['task_title'],
    );
  }
}
