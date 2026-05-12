class BrandModel {
  String? id;
  String name;
  String? image;

  BrandModel({this.id, required this.name, this.image});

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
  };

  factory BrandModel.fromJson(Map<String, dynamic> json, String docId) => BrandModel(
    id: docId,
    name: json['name'] ?? '',
    image: json['image'],
  );
}
