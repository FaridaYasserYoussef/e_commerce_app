<?php

include '../connection.php';

$userid = $_POST["user_id"];


$sql = "SELECT * FROM favorite_table WHERE user_id = $userid";

$result = $connectNow->query($sql);


if($result -> num_rows > 0){


    $resArr = array();
while ($row = $result->fetch_assoc()){

    $sql2 = "SELECT * FROM items_table WHERE item_id = " . $row["item_id"];

    $result2 = $connectNow->query($sql2);
    
    while($row2 = $result2->fetch_assoc()){

        $row["item_info"] = $row2;

       array_push($resArr, $row);

    }
    
    

}


echo(
json_encode(array(
    'success' => true,
    'favoritesItemData' => $resArr
))
);




}else{
    echo(
        json_encode(array(
            'success' => false
        ))
        );
        
}








