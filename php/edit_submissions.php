<?php
// edit_submission.php

include_once("dbconnect.php");

if (isset($_POST['submission_id']) && isset($_POST['updated_text'])) {
    $submission_id = $_POST['submission_id'];
    $updated_text = $_POST['updated_text'];

    $sql = "UPDATE tbl_submissions SET submission_text = ? WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("si", $updated_text, $submission_id);

    if ($stmt->execute()) {
        echo "success";
    } else {
        echo "failed";
    }

    $stmt->close();
} else {
    echo "missing_params"; 
}

$conn->close();
?>
