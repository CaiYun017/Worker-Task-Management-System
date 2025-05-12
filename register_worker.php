<?php
/*error_reporting(0);
header("Access-Control-Allow-Origin: *"); // running as crome app

if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$name = $_POST['full_name'];
$email = $_POST['email'];
$password = password_hash($_POST['password'], PASSWORD_DEFAULT);
//$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$address = $_POST['address'];

$sqlinsert="INSERT INTO `workers`(`full_name`, `email`, `password`, `phone`, `address`) VALUES ('$name','$email','$password','$phone','$address')";

try{
    if ($conn->query($sqlinsert) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }   
}catch (Exception $e) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}
	

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
} */

// register_worker.php

include("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $full_name = $_POST['full_name'];
    $email = $_POST['email'];
    $password = $_POST['password']; // 获取密码
    $phone = $_POST['phone'];
    $address = $_POST['address'];

    // 检查电子邮件是否已存在
    $check_email_query = "SELECT * FROM workers WHERE email = ?";
    $stmt = $conn->prepare($check_email_query);
    $stmt->bind_param("s", $email); // "s"表示字符串类型
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode(['status' => 'failure', 'message' => 'Email already exists']);
        exit();
    }

    // 密码加密
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // 插入数据库
    $sql = "INSERT INTO workers (full_name, email, password, phone, address) 
            VALUES (?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssss", $full_name, $email, $hashed_password, $phone, $address); // "sssss"表示5个字符串类型
    if ($stmt->execute()) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode(['status' => 'failure', 'message' => 'Failed to register']);
    }
}


?>
