<?php
include "../connection.php";

$user_id = $_POST["user_id"];
$item_id = $_POST["item_id"];

$initsql = "SELECT * FROM favorite_table WHERE user_id = $user_id AND item_id = $item_id";

$initResult = $connectNow->query($initsql);

if($initResult->num_rows == 1){
    echo json_encode(array("success"=> true));

}else{
    echo json_encode(array("success"=> false));

}
