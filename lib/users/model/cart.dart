class Cart{
  int? cart_id;
  int? user_id;
  int? item_id;
  int? quantity;
  String? color;
  String? size;
  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String? image;

  Cart({
    this.cart_id,
    this.user_id,
    this.item_id,
    this.quantity,
    this.color,
    this.size,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.sizes,
    this.colors,
    this.description,
    this.image
});

  factory Cart.fromJson(Map<String, dynamic> json){
    return Cart(
        cart_id: int.parse(json["cart_id"]),
        user_id: int.parse(json["user_id"]),
        item_id: int.parse(json["item_info"]["item_id"]),
        quantity: int.parse(json["quantity"]),
        color: json["color"].toString(),
        size: json["size"].toString(),
        name: json["item_info"]["name"].toString(),
        rating: double.parse(json["item_info"]["rating"]),
        tags: json["item_info"]["tags"].toString().replaceAll("[", "").replaceAll("]", "").split(","),
        price: double.parse(json["item_info"]["price"]),
        sizes: json["item_info"]["sizes"].toString().replaceAll("[", "").replaceAll("]", "").split(","),
        colors: json["item_info"]["colors"].toString().replaceAll("[", "").replaceAll("]", "").split(","),
        description: json["item_info"]["description"].toString(),
        image: json["item_info"]["image"].toString()
    );
  }

}