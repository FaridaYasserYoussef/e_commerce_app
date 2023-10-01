<?php
include "../connection.php";

$user_id = $_POST["user_id"];
$item_id = $_POST["item_id"];


$initsql = "DELETE FROM favorite_table WHERE user_id = $user_id AND item_id = $item_id";

$initResult = $connectNow->query($initsql);
$affectedRows = mysqli_affected_rows($connectNow);


if($affectedRows > 0){
    echo json_encode(array("success"=> true));
}else{
    echo json_encode(array("success"=> false));

}