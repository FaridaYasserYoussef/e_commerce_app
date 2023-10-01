<?php
include "../connection.php";

$orderId =  $_POST["order_id"];
$sql = "UPDATE orders_table SET `status` = 'received' WHERE order_id = $orderId";

$result = $connectNow->query($sql);


if($result == 1){
    echo json_encode(array("success"=> true));

}else{
    echo json_encode(array("success"=> false));
}