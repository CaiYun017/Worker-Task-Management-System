<?php
include_once("dbconnect.php");

header('Content-Type: application/json');

$id = $_POST['id'] ?? '';
$email = $_POST['email'] ?? '';
$phone = $_POST['phone'] ?? '';
$address = $_POST['address'] ?? '';

if (empty($id) || empty($email) || empty($phone) || empty($address)) {
    echo json_encode(["status" => "failed", "message" => "Missing required fields"]);
    exit();
}

$sql = "UPDATE workers SET email=?, phone=?, address=? WHERE id=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sssi", $email, $phone, $address, $id);

if ($stmt->execute()) {
    if ($stmt->affected_rows > 0) {
        echo json_encode(["status" => "success", "message" => "Profile updated"]);
    } else {
        echo json_encode(["status" => "failed", "message" => "No changes made"]);
    }
} else {
    echo json_encode(["status" => "failed", "message" => "Update error"]);
}
?>
