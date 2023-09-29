class Favorites{
  int? favorite_id;
  int? user_id;
  int? item_id;
  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String? image;

  Favorites({
    this.favorite_id,
    this.user_id,
    this.item_id,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.sizes,
    this.colors,
    this.description,
    this.image
  });

  factory Favorites.fromJson(Map<String, dynamic> json){
    return Favorites(
        favorite_id: int.parse(json["favorite_id"]),
        user_id: int.parse(json["user_id"]),
        item_id: int.parse(json["item_info"]["item_id"]),
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