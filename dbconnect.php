<?php
// 允许跨域请求（Flutter 通过 HTTP 调用时需要）
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

// 数据库连接信息
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "assignment_2";

// 创建连接
$conn = new mysqli($servername, $username, $password, $dbname);

// 检查连接是否失败
if ($conn->connect_error) {
    die(json_encode([
        "status" => "failed",
        "message" => "Connection failed: " . $conn->connect_error
    ]));
}
?>
