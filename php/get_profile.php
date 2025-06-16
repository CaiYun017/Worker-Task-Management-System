<?php
include_once("dbconnect.php");
header('Content-Type: application/json'); 

$worker_id = $_POST['worker_id'] ?? '';

if (empty($worker_id)) {
    echo json_encode(["status" => "failed", "message" => "Missing worker_id"]);
    exit();
}

$sql = "SELECT * FROM workers WHERE id = '$worker_id'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode([
        "status" => "success",
        "data" => $row
    ]);
} else {
    echo json_encode(["status" => "failed", "data" => null]);
}
?>
