class BrandCategoryModel {
  String? id;
  String brandId;
  String categoryId;

  BrandCategoryModel({this.id, required this.brandId, required this.categoryId});

  Map<String, dynamic> toJson() => {
    'brandId': brandId,
    'categoryId': categoryId,
  };

  factory BrandCategoryModel.fromJson(Map<String, dynamic> json, String docId) => BrandCategoryModel(
    id: docId,
    brandId: json['brandId'] ?? '',
    categoryId: json['categoryId'] ?? '',
  );
}
