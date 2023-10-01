<?php

include '../connection.php';


$minRating = 4.4;
$limit = 5;

$sql = "SELECT * FROM items_table WHERE rating >= '$minRating' ORDER BY rating DESC LIMIT $limit";

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








