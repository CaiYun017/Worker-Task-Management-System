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
    // Get worker_id from POST data
    $worker_id = $_POST['worker_id'] ?? '';
    
    if (empty($worker_id)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Worker ID is required'
        ]);
        exit;
    }
    
    // Query to get works assigned to this worker
    $sql = "SELECT id, title, description, assigned_to, date_assigned, due_date, status 
            FROM tbl_works 
            WHERE assigned_to = ? 
            ORDER BY due_date ASC";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $worker_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $works = [];
    while ($row = $result->fetch_assoc()) {
        $works[] = $row;
    }
    
    if (count($works) > 0) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Works retrieved successfully',
            'data' => $works
        ]);
    } else {
        echo json_encode([
            'status' => 'success',
            'message' => 'No works found for this worker',
            'data' => []
        ]);
    }
    
    $stmt->close();
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Only POST method allowed'
    ]);
}

$conn->close();
?>