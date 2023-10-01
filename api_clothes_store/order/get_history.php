<?php
include "../connection.php";

$userId = $_POST["user_id"];

$sql = "SELECT * FROM orders_table WHERE user_id = $userId AND status = 'received' ORDER BY dateTime DESC";

$result = $connectNow->query($sql);


if($result -> num_rows > 0){


    $resArr = array();
while ($row = $result->fetch_assoc()){

    array_push($resArr, $row);
    
    

}


echo(
json_encode(array(
    'success' => true,
    'OrdersData' => $resArr
))
);




}else{
    echo(
        json_encode(array(
            'success' => false
        ))
        );
        
}
