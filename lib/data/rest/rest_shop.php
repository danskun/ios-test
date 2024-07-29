<?php
header('Content-Type: application/json');
require "../config/connectionDB.php";

function readAll($conn) {
    $stmt = $conn->prepare("SELECT * FROM trx_shop");
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result && $result->num_rows > 0) {
        $data = $result->fetch_all(MYSQLI_ASSOC);
        
        foreach ($data as &$row) {
            if (!empty($row['image'])) {
                $row['image'] = base64_encode($row['image']);
            }
        }

        echo json_encode(["OK" => $data]);
    } else {
        echo json_encode("ERROR");
    }
    
    $stmt->close();
}

function create($conn)
{
    $codeShop   = "SHP-" . mt_rand(1,9999);
    $name       = $_POST['name'];
    $timeOpen   = $_POST['time_open'];
    $timeClosed = $_POST['time_closed'];
    $location   = $_POST['location'];
    $image      = $_POST['image'];
    $imageData  = base64_decode($image);

    $stmtShop = $conn->prepare("INSERT INTO trx_shop VALUES(?, ?, ?, ?, ?, ?)");
    $stmtShop->bind_param('ssssss', $codeShop, $name, $timeOpen, $timeClosed, $location, $imageData);

    if ($stmtShop->execute()) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR");
    }
}

function update($conn)
{
    $codeShop   = $_POST['cd_shop'];
    $name       = $_POST['name'];
    $timeOpen   = $_POST['time_open'];
    $timeClosed = $_POST['time_closed'];
    $location   = $_POST['location'];
    $image      = $_POST['image'];
    $imageData  = base64_decode($image);

    $stmtShop = $conn->prepare("UPDATE trx_shop SET name = ?, time_open = ?, time_closed = ?, location = ?, image = ? WHERE cd_shop = ?");
    $stmtShop->bind_param('ssssss', $name, $timeOpen, $timeClosed, $location, $imageData, $codeShop);

    if ($stmtShop->execute()) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR: Database update failed.");
    }
}

function delete($conn)
{
    $codeShop   = $_POST['cd_shop'];

    $result = mysqli_query($conn, "DELETE FROM trx_shop WHERE cd_shop = '" . $codeShop . "'");

    if ($result) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR");
    }
}

if ($_POST['type'] == "readAll") {
    readAll($conn);
} else if ($_POST['type'] == "create") {
    create($conn);
} else if ($_POST['type'] == "update") {
    update($conn);
} else if ($_POST['type'] == "delete") {
    delete($conn);
}