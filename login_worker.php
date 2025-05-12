<?php
/*ob_start();
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');

include_once("dbconnect.php");

try {
    // 验证POST数据
    if ($_SERVER['REQUEST_METHOD'] !== 'POST' || empty($_POST)) {
        throw new Exception('Invalid request');
    }

    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';

    if (empty($email) || empty($password)) {
        throw new Exception('Email and password required');
    }

    // 使用预处理语句防止SQL注入
    $stmt = $conn->prepare("SELECT * FROM `workers` WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $worker = $result->fetch_assoc();
        
        // 密码验证（保持与您现有SHA1兼容）
        if (password_verify($password, $worker['password'])) {
            unset($worker['password']); // 移除敏感信息

            echo json_encode([
                'status' => 'success',
                'data' => [$worker]
            ]);
        } else {
            throw new Exception('Invalid password');
        }
    } else {
        throw new Exception('User not found');
    }
} catch (Exception $e) {
    echo json_encode([
        'status' => 'failed',
        'message' => $e->getMessage()
    ]);
}

$conn->close();
ob_end_flush(); */

/*header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
include("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // 查询数据库
    $sql = "SELECT * FROM 'workers' WHERE email = '$email'";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        
        // 使用 password_verify 来验证密码
        if (password_verify($password, $row['password'])) {
            echo json_encode(['status' => 'success', 'worker' => $row]);
        } else {
            echo json_encode(['status' => 'failure', 'message' => 'Incorrect password']);
        }
    } else {
        echo json_encode(['status' => 'failure', 'message' => 'Email not found']);
    }
}*/

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

include("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // 查找用户
    $sql = "SELECT * FROM workers WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email); // "s"表示字符串类型
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        
        // 使用 password_verify 来验证密码
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