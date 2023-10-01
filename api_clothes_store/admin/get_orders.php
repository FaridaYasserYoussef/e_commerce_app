<?php
include "../connection.php";


$sql = "SELECT * FROM orders_table WHERE status = 'new' ORDER BY `dateTime` DESC";

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
