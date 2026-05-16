class ProductModel {
  String? id;
  String name;
  String description;
  double price;
  String categoryId;
  String brandId;
  List<String> images;
  int stock;
  bool isFeatured;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.brandId,
    required this.images,
    required this.stock,
    this.isFeatured = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'categoryId': categoryId,
    'brandId': brandId,
    'images': images,
    'stock': stock,
    'isFeatured': isFeatured,
  };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    categoryId: json['categoryId'] ?? '',
    brandId: json['brandId'] ?? '',
    images: json['images'] != null 
        ? List<String>.from(json['images']) 
        : (json['image'] != null ? [json['image'].toString()] : []),
    stock: json['stock'] ?? 0,
    isFeatured: json['isFeatured'] ?? false,
  );
}
