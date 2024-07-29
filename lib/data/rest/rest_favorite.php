<?php
header('Content-Type: application/json');
require "../config/connectionDB.php";

function readAll($conn)
{
    $codeUser = $_POST['cd_user'];
    
    $stmt = $conn->prepare("SELECT tf.cd_user, tf.favorite, ts.* FROM trx_shop ts, trx_favorite tf WHERE ts.cd_shop = tf.cd_shop AND tf.favorite = '1' AND tf.cd_user = ?");
    $stmt->bind_param('s', $codeUser);
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

function readFavorite($conn)
{    
    $codeUser = $_POST['cd_user'];
    $codeShop = $_POST['cd_shop'];

    $result = mysqli_query($conn, "SELECT * FROM trx_favorite WHERE cd_user = '" . $codeUser . "' AND cd_shop = '" . $codeShop . "'");
    $read   = mysqli_fetch_assoc($result);

    if (mysqli_num_rows($result) == 1) {
        echo json_encode(["OK" => $read]);
    } else {
        echo json_encode("ERROR");
    }
}

function create($conn)
{
    $codeUser   = $_POST['cd_user'];
    $codeShop   = $_POST['cd_shop'];
    $favorite   = "1";

    $stmt = $conn->prepare("SELECT * FROM trx_favorite WHERE cd_user = ? AND cd_shop = ?");
    $stmt->bind_param('ss', $codeUser, $codeShop);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result && $result->num_rows > 0) {
        $update = mysqli_query($conn, "UPDATE trx_favorite SET favorite = '" . $favorite . "' WHERE cd_user = '" . $codeUser . "' AND cd_shop = '" . $codeShop . "'");
        if ($update) {
            echo json_encode("OK");
        } else {
            echo json_encode("ERROR");
        }
    } else {
        $insert = mysqli_query($conn, "INSERT INTO trx_favorite VALUES('" . $codeShop . "', '" . $codeUser . "', '" . $favorite . "')");
        if ($insert) {
            echo json_encode("OK");
        } else {
            echo json_encode("ERROR");
        }
    }

    $stmt->close();
    $conn->close();
}

function delete($conn)
{
    $codeUser   = $_POST['cd_user'];
    $codeShop   = $_POST['cd_shop'];
    $favorite   = "0";

    $update = mysqli_query($conn, "UPDATE trx_favorite SET favorite = '" . $favorite . "' WHERE cd_user = '" . $codeUser . "' AND cd_shop = '" . $codeShop . "'");
    if ($update) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR");
    }
}

if ($_POST['type'] == "readAll") {
    readAll($conn);
} else if ($_POST['type'] == "readFavorite") {
    readFavorite($conn);
} else if ($_POST['type'] == "create") {
    create($conn);
} else if ($_POST['type'] == "delete") {
    delete($conn);
}