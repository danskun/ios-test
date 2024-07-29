<?php
header('Content-Type: application/json');
require "../config/connectionDB.php";

function sign_up($conn)
{
    $codeUser   = "USR-" . mt_rand(1,9999);
    $name       = $_POST['name'];
    $email      = $_POST['email'];
    $password   = md5($_POST['password']);
    $phone      = $_POST['phone'];
    $level      = "user";

    $resultUser = mysqli_query($conn, "INSERT INTO mst_user VALUES('" . $codeUser . "', '" . $name . "', '" . $email . "', '" . $password . "', '" . $phone . "', null)");
    $resultSign = mysqli_query($conn, "INSERT INTO mst_sign(cd_user, email, password, level) VALUES('" . $codeUser . "', '" . $email . "', '" . $password . "', '" . $level . "')");

    if ($resultUser && $resultSign) {
        echo json_encode("OK");
    } else {
        echo json_encode("ERROR");
    }
}

function sign_in($conn)
{
    $email      = $_POST['email'];
    $password   = md5($_POST['password']);

    $result = mysqli_query($conn, "SELECT * FROM mst_sign WHERE email = '" . $email . "' AND password = '" . $password . "'");
    $read   = mysqli_fetch_assoc($result);

    if (mysqli_num_rows($result) == 1) {
        echo json_encode(["OK" => $read]);
    } else {
        echo json_encode("ERROR");
    }
}

if ($_POST['type'] == 'sign_up') {
    sign_up($conn);
} else if ($_POST['type'] == 'sign_in') {
    sign_in($conn);
}
