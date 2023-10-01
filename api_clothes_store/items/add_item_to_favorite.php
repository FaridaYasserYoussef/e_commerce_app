<?php
include "../connection.php";

$user_id = $_POST["user_id"];
$item_id = $_POST["item_id"];


$initsql = "SELECT * FROM favorite_table WHERE user_id = $user_id AND item_id = $item_id";

$initResult = $connectNow->query($initsql);

if($initResult->num_rows == 0){

 $sql = "INSERT INTO favorite_table (user_id, item_id) VALUES ($user_id, $item_id)";
 $result = $connectNow->query($sql);
 $affectedRows = mysqli_affected_rows($connectNow);



 if($affectedRows >  0){
    echo json_encode(array("success"=> true));
}else{
    echo json_encode(array("success"=> false));

}


    
}