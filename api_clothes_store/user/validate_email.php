<?php

include "../connection.php";
$userEmail = $_POST["user_email"];

$sql = "SELECT * FROM users_table WHERE user_email = '$userEmail'";
;

$result = $connectNow->query($sql);



if($result->num_rows > 0 ){
    echo json_encode(array("emailFound"=> true));
}else if($result->num_rows == 0){
    echo json_encode(array("emailFound"=> false));

}