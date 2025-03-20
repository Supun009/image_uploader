change actual domain or ip on imageUploader>lib>constant> http://10.0.2.2/backend
            and backend>upload_images.php>     $image_url = 'http://10.0.2.2/uploads/



-- Create database
CREATE DATABASE IF NOT EXISTS image_app_db;

-- Use the database
USE image_app_db;

-- Create images table
CREATE TABLE IF NOT EXISTS images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL,
    comment TEXT NOT NULL,
    timestamp DATETIME NOT NULL
);

-- Add index on timestamp for faster sorting
CREATE INDEX idx_timestamp ON images(timestamp);