<?php

include '../connection.php';




$sql = "SELECT * FROM items_table ORDER BY item_id DESC";

$result = $connectNow->query($sql);


if($result -> num_rows > 0){


    $resArr = array();
$key = 0;
while ($row = $result->fetch_assoc()){
        
    $resArr[$key] = $row;

    $key++;
    

}


echo(
json_encode(array(
    'success' => true,
    'clothesItemData' => $resArr
))
);




}else{
    echo(
        json_encode(array(
            'success' => false
        ))
        );
        
}








