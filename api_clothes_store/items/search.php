<?php
header('Content-Type: application/json');

include '../connection.php';



$typedKeyWord = $_POST['typedKeyWord'];

$sql = "SELECT * FROM items_table WHERE  name LIKE '%$typedKeyWord%'";
$resultOfQuery = $connectNow->query($sql);


if($resultOfQuery->num_rows > 0){

    $itemsRecords = array();
     
    while($rowFound = $resultOfQuery->fetch_assoc()){
        array_push($itemsRecords, $rowFound);

    }


    echo json_encode(array("success"=> true, "itemsData"=> $itemsRecords));
}else{
    echo json_encode(array("success"=> false));

}