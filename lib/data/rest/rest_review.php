<?php
header('Content-Type: application/json');
require "../config/connectionDB.php";

function readAll($conn)
{
    $codeUser = $_POST['cd_user'];
    $codeShop = $_POST['cd_shop'];
    
    $stmt = $conn->prepare("SELECT tr.cd_review AS cd_review, mu.cd_user AS cd_user, mu.name AS name, tr.*, mu.image AS image FROM trx_review tr, mst_user mu WHERE tr.cd_user = mu.cd_user AND tr.cd_shop = ? AND tr.cd_user = ?");
    $stmt->bind_param('ss', $codeShop, $codeUser);
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

function readAllComment($conn)
{
    $codeShop = $_POST['cd_shop'];
    $codeUser = $_POST['cd_user'];
    
    $stmt = $conn->prepare("SELECT tr.cd_review AS cd_review, mu.cd_user AS cd_user, mu.name AS name, tr.*, mu.image AS image FROM trx_review tr, mst_user mu WHERE tr.cd_user = mu.cd_user AND tr.cd_shop = ? AND NOT tr.cd_user = ?");
    $stmt->bind_param('ss', $codeShop, $codeUser);
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

function readAvgRating($conn)
{
    $codeShop  = $_POST['cd_shop'];

    $result = mysqli_query($conn, "SELECT cd_shop, AVG(rating) AS rating FROM trx_review WHERE cd_shop = '" . $codeShop . "'");
    $read   = mysqli_fetch_assoc($result);

    if (mysqli_num_rows($result) == 1) {
        echo json_encode(["OK" => $read]);
    } else {
        echo json_encode("ERROR");
    }
}

function readTotRating($conn)
{
    $codeShop  = $_POST['cd_shop'];

    $result = mysqli_query($conn, "SELECT cd_shop, SUM(rating) AS rating FROM trx_review WHERE cd_shop = '" . $codeShop . "'");
    $read   = mysqli_fetch_assoc($result);

    if (mysqli_num_rows($result) == 1) {
        echo json_encode(["OK" => $read]);
    } else {
        echo json_encode("ERROR");
    }
}

function create($conn)
{
    $codeReview = "REV-" . mt_rand(1,9999);
    $codeUser   = $_POST['cd_user'];
    $codeShop   = $_POST['cd_shop'];
    $rating     = $_POST['rating'];
    $comment    = $_POST['comment'];
    $rasa    = $_POST['rasa'];
    $kebersihan    = $_POST['kebersihan'];
    $pelayanan    = $_POST['pelayanan'];
    $harga    = $_POST['harga'];
    $vibes    = $_POST['vibes'];

    $result = mysqli_query($conn, "INSERT INTO trx_review VALUES('" . $codeReview . "', '" . $codeUser . "', '" . $codeShop . "', '" . $rating . "', '" . $comment . "', '" . $rasa . "', '" . $kebersihan . "', '" . $pelayanan . "', '" . $harga . "', '" . $vibes . "')");

    if ($result) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR");
    }
}

function delete($conn)
{
    $codeReview = $_POST['cd_review'];

    $result = mysqli_query($conn, "DELETE FROM trx_review WHERE cd_review = '" . $codeReview . "'");

    if ($result) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR");
    }
}

if ($_POST['type'] == "readAll") {
    readAll($conn);
} else if ($_POST['type'] == "readAllComment") {
    readAllComment($conn);
} else if ($_POST['type'] == "readAvgRating") {
    readAvgRating($conn);
} else if ($_POST['type'] == "readTotRating") {
    readTotRating($conn);
} else if ($_POST['type'] == "create") {
    create($conn);
} else if ($_POST['type'] == "delete") {
    delete($conn);
}