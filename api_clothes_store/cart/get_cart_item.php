<?php

include '../connection.php';

$user_id = $_POST["user_id"];


$sql = "SELECT * FROM cart_table WHERE user_id = $user_id";

$result = $connectNow->query($sql);


if($result -> num_rows > 0){


    $resArr = array();
$key = 0;
while ($row = $result->fetch_assoc()){

    $sql2 = "SELECT * FROM items_table WHERE item_id = " . $row['item_id'];

    $result2 = $connectNow->query($sql2);

    $row["item_info"] = $result2->fetch_assoc();


        
    $resArr[$key] = $row;

    $key++;
    

}


echo(
json_encode(array(
    'success' => true,
    'CartData' => $resArr
))
);




}else{
    echo(
        json_encode(array(
            'success' => false
        ))
        );
        
}








