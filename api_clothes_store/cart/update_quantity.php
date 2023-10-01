<?php
include "../connection.php";

$cartId =  $_POST["cart_id"];
$newQuantity = $_POST["new_quantity"];
$sql = "UPDATE cart_table SET quantity = $newQuantity WHERE cart_id = $cartId";

$result = $connectNow->query($sql);


if($result == 1){
    echo json_encode(array("success"=> true));

}else{
    echo json_encode(array("success"=> false));
}