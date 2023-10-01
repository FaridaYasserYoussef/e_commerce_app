<?php
include "../connection.php";


$initsql = "SELECT * FROM cart_table";
$initres = $connectNow->query($initsql);

$initrows = $initres->num_rows;


$items_to_delete = $_POST["items_to_delete"];

$to_be_deleted_arr = explode(",", $items_to_delete);

foreach($to_be_deleted_arr as $cart_id){

    $sql = "DELETE FROM cart_table WHERE cart_id = '$cart_id'";
    $connectNow->query($sql);


}


$finalsql = "SELECT * FROM cart_table";
$finalres = $connectNow->query($finalsql);

$finalrows = $finalres->num_rows;


if( ($finalrows +  count($to_be_deleted_arr)) == $initrows){
    echo json_encode(array("success"=> true));

}else{
    echo json_encode(array("success"=> false));
}

