<?php
header('Content-Type: application/json');
require "../config/connectionDB.php";

function read($conn) {
    $codeUser = $_POST['cd_user'];
    
    $stmt = $conn->prepare("SELECT * FROM mst_user WHERE cd_user = ?");
    $stmt->bind_param('s', $codeUser);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result && $result->num_rows == 1) {
        $data = $result->fetch_assoc();
        
        if (!empty($data['image'])) {
            $data['image'] = base64_encode($data['image']);
        }

        echo json_encode(["OK" => $data]);
    } else {
        echo json_encode("ERROR");
    }
    
    $stmt->close();
}

function update($conn)
{
    $codeUser   = $_POST['cd_user'];
    $name       = $_POST['name'];
    $email      = $_POST['email'];
    $password   = md5($_POST['password']);
    $phone      = $_POST['phone'];
    $image      = $_POST['image'];
    $imageData  = base64_decode($image);

    $stmtUser = $conn->prepare("UPDATE mst_user SET name = ?, email = ?, password = ?, phone = ?, image = ? WHERE cd_user = ?");
    $stmtUser->bind_param('ssssss', $name, $email, $password, $phone, $imageData, $codeUser);

    $stmtSign = $conn->prepare("UPDATE mst_sign SET email = ?, password = ? WHERE cd_user = ?");
    $stmtSign->bind_param('sss', $email, $password, $codeUser);

    if ($stmtUser->execute() && $stmtSign->execute()) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR: Database update failed.");
    }
}

function updateAdmin($conn)
{
    $codeUser   = $_POST['cd_user'];
    $name       = $_POST['name'];
    $password   = md5($_POST['password']);
    $image      = $_POST['image'];
    $imageData  = base64_decode($image);

    $stmtUser = $conn->prepare("UPDATE mst_user SET name = ?, email = ?, password = ?, phone = ?, image = ? WHERE cd_user = ?");
    $stmtUser->bind_param('ssssss', $name, $email, $password, $phone, $imageData, $codeUser);

    $stmtSign = $conn->prepare("UPDATE mst_sign SET email = ?, password = ? WHERE cd_user = ?");
    $stmtSign->bind_param('sss', $email, $password, $codeUser);

    if ($stmtUser->execute() && $stmtSign->execute()) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR: Database update failed.");
    }
}

if ($_POST['type'] == "read") {
    read($conn);
} else if ($_POST['type'] == "update") {
    update($conn);
} else if ($_POST['type'] == "update") {
    update($conn);
}