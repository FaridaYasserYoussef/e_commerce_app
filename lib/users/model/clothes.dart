import 'package:clothes_app/users/model/favorites.dart';

class Clothes{
   int? item_id;
   String? name;
   double? rating;
   List<String>? tags;
   double? price;
   List<String>? sizes;
   List<String>? colors;
   String? description;
   String? image;

   Clothes({
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

   factory Clothes.fromJson(Map<String, dynamic> json) => Clothes(
    item_id : int.parse(json["item_id"]),
     name: json["name"].toString(),
     rating: double.parse(json["rating"]),
     tags: json["tags"].replaceAll('[', '').replaceAll(']', '').split(','),
     price: double.parse(json["price"]),
     sizes: json["sizes"].replaceAll('[', '').replaceAll(']', '').split(','),
     colors: json["colors"].replaceAll('[', '').replaceAll(']', '').split(','),
     description: json["description"],
     image: json["image"]


   );

   factory Clothes.fromFavorite(Favorites favorite) => Clothes(
     item_id: favorite.item_id,
     name: favorite.name,
     rating: favorite.rating,
     tags: favorite.tags,
     price: favorite.price,
     sizes: favorite.sizes,
     colors: favorite.colors,
     description: favorite.description,
     image: favorite.image

   );


   Map<String, dynamic> toJson(){
     return {
       'item_id': item_id,
       'name': name,
       'rating': rating,
       'tags': tags,
       'price': price,
       'sizes': sizes,
       'colors': colors,
       'description': description,
       'image': image
     };
   }

}