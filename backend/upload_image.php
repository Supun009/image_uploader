<?php
// File: upload_image.php

// Include database connection
require_once './db.php';

// Upload folder
$upload_dir = '../uploads/';

// Create upload directory if it doesn't exist
if (!file_exists($upload_dir)) {
    mkdir($upload_dir, 0777, true);
}

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid request method'
    ]);
    exit;
}



// Check if all required fields are present
if (!isset($_POST['comment']) || !isset($_FILES['image'])) {
    echo json_encode([
        'success' => false,
        'message' => 'Missing required fields'
    ]);
    exit;
}

$comment = $_POST['comment'];
$image = $_FILES['image'];

// Check if there was an error uploading the file
if ($image['error'] !== UPLOAD_ERR_OK) {
    echo json_encode([
        'success' => false,
        'message' => 'Error uploading file: ' . $image['error']
    ]);
    exit;
}

// Generate unique filename
$filename = uniqid() . '_' . basename($image['name']);
$target_path = $upload_dir . $filename;

// Validate file type
$allowed_types = ['image/jpeg', 'image/png', 'image/gif'];
$file_type = mime_content_type($image['tmp_name']);

if (!in_array($file_type, $allowed_types)) {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid file type. Only JPG, PNG and GIF are allowed.'
    ]);
    exit;
}

// Move uploaded file to target directory
if (move_uploaded_file($image['tmp_name'], $target_path)) {
    // File uploaded successfully
    // Generate public URL for the image
    $image_url = 'http://10.0.2.2/uploads/' . $filename;
    
    try {
        // Insert record into database using prepared statement
        $stmt = $pdo->prepare("INSERT INTO images (image_url, comment, timestamp) VALUES (?, ?, NOW())");
        $stmt->execute([$image_url, $comment]);
        
        echo json_encode([
            'success' => true,
            'message' => 'Image uploaded successfully',
            'image_url' => $image_url
        ]);
    } catch (PDOException $e) {
        // Database insert failed
        echo json_encode([
            'success' => false,
            'message' => 'Error inserting record: ' . $e->getMessage()
        ]);
        
        // Remove the uploaded file since we couldn't record it in the database
        unlink($target_path);
    }
} else {
    // File upload failed
    echo json_encode([
        'success' => false,
        'message' => 'Failed to move uploaded file'
    ]);
}
?>

