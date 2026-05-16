class BrandModel {
  String? id;
  String name;
  String? image;
  bool isFeatured;

  BrandModel({this.id, required this.name, this.image, this.isFeatured = false});

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'isFeatured': isFeatured,
  };

  factory BrandModel.fromJson(Map<String, dynamic> json, String docId) => BrandModel(
    id: docId,
    name: json['name'] ?? '',
    image: json['image'],
    isFeatured: json['isFeatured'] ?? false,
  );
}
