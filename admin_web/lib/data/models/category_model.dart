class CategoryModel {
  String? id;
  String name;
  String? image;
  String? description;

  CategoryModel({this.id, required this.name, this.image, this.description});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'description': description,
  };

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    description: json['description'],
  );
}
