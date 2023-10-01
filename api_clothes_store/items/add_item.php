<?php
include '../connection.php';

$name = $_POST["name"];
$rating = $_POST["rating"];
$tags = $_POST["tags"];
$price = $_POST["price"];
$sizes = $_POST["sizes"];
$colors = $_POST["colors"];
$description = $_POST["description"];
$image = $_POST["image"];


$sql = "INSERT INTO items_table (name, rating, tags, price, sizes, colors, description, image) VALUES ('$name', $rating, '$tags', $price, '$sizes', '$colors', '$description', '$image')";

$result = $connectNow->query($sql);



if($result == 1){
    echo json_encode(array("success"=> true));
}else{
    echo json_encode(array("success"=> false));

}