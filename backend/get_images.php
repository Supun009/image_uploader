<?php
// File: get_images.php

require_once './db.php';


try {
    // Get all images ordered by timestamp (newest first)
    $stmt = $pdo->query("SELECT id, image_url, comment, timestamp FROM images ORDER BY timestamp DESC");
    $images = $stmt->fetchAll();
    
    // Convert id to integer for consistency
    foreach ($images as &$image) {
        $image['id'] = (int)$image['id'];
    }
    
    // Return images as JSON
    echo json_encode($images);
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Error fetching images: ' . $e->getMessage()
    ]);
}
?>