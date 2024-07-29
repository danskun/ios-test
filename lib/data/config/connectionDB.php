<?php

$servername = "127.0.0.1";
$username = "root";
$password = "123";
$database = "db_jakeats";

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    // echo ("Connected successfully");
}