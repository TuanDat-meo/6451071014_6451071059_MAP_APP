class BobaModel {
  String? id;
  String name;
  double price;
  String image;
  String description;
  String category;

  BobaModel({
    this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
    };
  }

  factory BobaModel.fromJson(Map<dynamic, dynamic> json, String id) {
    return BobaModel(
      id: id,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
