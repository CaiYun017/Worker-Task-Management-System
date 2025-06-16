<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

include("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    
    $sql = "SELECT * FROM workers WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email); 
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        
        
        if (password_verify($password, $user['password'])) {
            echo json_encode(['status' => 'success', 'worker' => $user]);
        } else {
            echo json_encode(['status' => 'failed', 'message' => 'Invalid email or password']);
        }
    } else {
        echo json_encode(['status' => 'failed', 'message' => 'Invalid email or password']);
    }
}
?>