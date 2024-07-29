<?php
header('Content-Type: application/json');
require "../config/connectionDB.php";

function readAll($conn) {
    $stmt = $conn->prepare("SELECT * FROM trx_promo");
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
    $codePromo   = "PRM-" . mt_rand(1,9999);
    $description = $_POST['description'];
    $dateOpen    = $_POST['date_open'];
    $dateClosed  = $_POST['date_closed'];
    $minTrans    = $_POST['min_trans'];
    $terms       = $_POST['terms'];
    $image       = $_POST['image'];
    $imageData   = base64_decode($image);

    $stmtShop = $conn->prepare("INSERT INTO trx_promo VALUES(?, ?, ?, ?, ?, ?, ?)");
    $stmtShop->bind_param('sssssss', $codePromo, $description, $dateOpen, $dateClosed, $minTrans, $terms, $imageData);

    if ($stmtShop->execute()) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR");
    }
}

function update($conn)
{
    $codePromo   = $_POST['cd_promo'];
    $description = $_POST['description'];
    $dateOpen    = $_POST['date_open'];
    $dateClosed  = $_POST['date_closed'];
    $minTrans    = $_POST['min_trans'];
    $terms       = $_POST['terms'];
    $image       = $_POST['image'];
    $imageData   = base64_decode($image);

    $stmtShop = $conn->prepare("UPDATE trx_promo SET description = ?, date_open = ?, date_closed = ?, min_trans = ?, terms = ?, image = ? WHERE cd_promo = ?");
    $stmtShop->bind_param('sssssss', $description, $dateOpen, $dateClosed, $minTrans, $terms, $imageData, $codePromo);

    if ($stmtShop->execute()) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR: Database update failed.");
    }
}

function delete($conn)
{
    $codePromo   = $_POST['cd_promo'];

    $result = mysqli_query($conn, "DELETE FROM trx_promo WHERE cd_promo = '" . $codePromo . "'");

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