<?php
include '../connection.php';

$userId = $_POST["user_id"];
$itemId = $_POST["item_id"];
$quantity = $_POST["quantity"];
$color = $_POST["color"];
$size = $_POST["size"];



$sqlinit = "SELECT * FROM cart_table WHERE `user_id` = '$userId' AND `item_id` = '$itemId' AND `color` = '$color' AND `size` = '$size'";
$resultinit = $connectNow->query($sqlinit);


if($resultinit->num_rows > 0){
   $row = $resultinit->fetch_assoc();
   $newQuantity = $row["quantity"] + $quantity;
   $updateQuery = "UPDATE cart_table SET quantity = $newQuantity WHERE cart_id = " . $row["cart_id"];
   $updateresult = $connectNow->query($updateQuery);

   if($updateresult == 1){
    echo json_encode(array("success"=> true));
}else{
    echo json_encode(array("success"=> false));

}



}elseif($resultinit->num_rows == 0){

    $sql = "INSERT INTO cart_table (user_id, item_id, quantity, color, size) VALUES ('$userId', '$itemId', '$quantity', '$color', '$size')";

    $result = $connectNow->query($sql);
    
    
    
    if($result == 1){
        echo json_encode(array("success"=> true));
    }else{
        echo json_encode(array("success"=> false));
    
    }

}



