<?php
header('Content-Type: application/json');

include '../connection.php';

//Post 

//Get

$userEmail = $_POST['user_email'];
$userPassword = md5($_POST['user_password']);

$sql = "SELECT * FROM users_table WHERE   user_email = '$userEmail' AND  user_password = '$userPassword'";
$resultOfQuery = $connectNow->query($sql);


if($resultOfQuery->num_rows > 0){

    $userRecord = array();
     
    while($rowFound = $resultOfQuery->fetch_assoc()){
        $userRecord = $rowFound;

    }


    echo json_encode(array("success"=> true, "userData"=> $userRecord));
}else{
    echo json_encode(array("success"=> false));

}