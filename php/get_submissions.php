<?php
include_once("dbconnect.php");

$worker_id = $_POST["worker_id"] ?? null;

if (!$worker_id) {
    echo json_encode(["error" => "Missing worker_id"]);
    exit();
}


$sql = "SELECT s.id AS submission_id, s.submission_text, s.submitted_at, 
               w.title AS task_title
        FROM tbl_submissions s
        JOIN tbl_works w ON s.work_id = w.id
        WHERE s.worker_id = ?
        ORDER BY s.submitted_at DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

$submissions = [];
while ($row = $result->fetch_assoc()) {
    $submissions[] = [
        "id" => $row["submission_id"],
        "submission_text" => $row["submission_text"],
        "submitted_at" => $row["submitted_at"],
        "task_title" => $row["task_title"]
    ];
}

echo json_encode($submissions);
?>
