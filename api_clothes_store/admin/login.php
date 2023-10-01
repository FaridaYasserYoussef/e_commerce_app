<?php

include '../connection.php';

$adminEmail = $_POST['admin_email'];
$adminPassword = $_POST['admin_password'];

$sql = "SELECT * FROM admins_table WHERE   admin_email = '$adminEmail' AND  admin_password = '$adminPassword'";
$resultOfQuery = $connectNow->query($sql);


if($resultOfQuery->num_rows > 0){

    $admiRecord = array();
     
    while($rowFound = $resultOfQuery->fetch_assoc()){
        $admiRecord = $rowFound;

    }


    echo json_encode(array("success"=> true, "adminData"=> $admiRecord));
}else{
    echo json_encode(array("success"=> false));

}

