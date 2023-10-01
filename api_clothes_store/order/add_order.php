<?php
include "../connection.php";

$userId = $_POST["user_id"];
$selectedItems = $_POST["selectedItems"];
$deliverySystem = $_POST["deliverySystem"];
$paymentSystem = $_POST["paymentSystem"];
$note = $_POST["note"];
$totalAmount = $_POST["totalAmount"];
$image = $_POST["image"];
$status = $_POST["status"];
$shipmentAddress = $_POST["shipmentAddress"];
$phoneNumber = $_POST["phoneNumber"];
$imageFile = $_POST["imageFile"];
$items_to_delete = $_POST["selectedcartIDs"];

$sql = "INSERT INTO orders_table (user_id, selectedItems, deliverySystem, paymentSystem, note, totalAmount, image, status, shipmentAddress, phoneNumber) VALUES ($userId,'$selectedItems', '$deliverySystem', '$paymentSystem', '$note', $totalAmount, '$image', '$status',  '$shipmentAddress', '$phoneNumber')";

$result = $connectNow->query($sql);



if($result == 1){
// upload image to server
$imageFileOfTransactionProof = base64_decode($imageFile);
file_put_contents("../transactions_proof_images/". $image, $imageFileOfTransactionProof);

$to_be_deleted_arr = explode(",", $items_to_delete);

foreach($to_be_deleted_arr as $cart_id){

    $sql2 = "DELETE FROM cart_table WHERE cart_id = '$cart_id'";
    $connectNow->query($sql2);

}


    echo json_encode(array("success"=> true));
}else{
    echo json_encode(array("success"=> false));

}
