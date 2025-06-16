<?php
// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    exit(0);
}

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Get data from POST request
    $work_id = $_POST['work_id'] ?? '';
    $worker_id = $_POST['worker_id'] ?? '';
    $submission_text = $_POST['submission_text'] ?? '';
    
    // Validate required fields
    if (empty($work_id) || empty($worker_id) || empty($submission_text)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'All fields are required (work_id, worker_id, submission_text)'
        ]);
        exit;
    }
    
    // Check if the work exists and is assigned to this worker
    $check_sql = "SELECT id FROM tbl_works WHERE id = ? AND assigned_to = ?";
    $check_stmt = $conn->prepare($check_sql);
    $check_stmt->bind_param("ii", $work_id, $worker_id);
    $check_stmt->execute();
    $check_result = $check_stmt->get_result();
    
    if ($check_result->num_rows == 0) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Work not found or not assigned to this worker'
        ]);
        $check_stmt->close();
        exit;
    }
    $check_stmt->close();
    
    // Insert submission into tbl_submissions
    $insert_sql = "INSERT INTO tbl_submissions (work_id, worker_id, submission_text) VALUES (?, ?, ?)";
    $insert_stmt = $conn->prepare($insert_sql);
    $insert_stmt->bind_param("iis", $work_id, $worker_id, $submission_text);
    
    if ($insert_stmt->execute()) {
        // Update work status to 'completed'
        $update_sql = "UPDATE tbl_works SET status = 'completed' WHERE id = ?";
        $update_stmt = $conn->prepare($update_sql);
        $update_stmt->bind_param("i", $work_id);
        $update_stmt->execute();
        $update_stmt->close();
        
        echo json_encode([
            'status' => 'success',
            'message' => 'Work submission saved successfully',
            'submission_id' => $conn->insert_id
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to save submission: ' . $conn->error
        ]);
    }
    
    $insert_stmt->close();
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Only POST method allowed'
    ]);
}

$conn->close();
?>