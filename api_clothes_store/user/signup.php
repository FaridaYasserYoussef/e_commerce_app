<?php
header('Content-Type: application/json');

include '../connection.php';

//Post 

//Get

$userName = $_POST['user_name'];
$userEmail = $_POST['user_email'];
$userPassword = md5($_POST['user_password']);

$sql = "INSERT INTO users_table (user_name, user_email, user_password) VALUES ('$userName', '$userEmail', '$userPassword')";
$resultOfQuery = $connectNow->query($sql);


if($resultOfQuery == 1){
    echo json_encode(array("success"=> true));
}else{
    echo json_encode(array("success"=> false));

}