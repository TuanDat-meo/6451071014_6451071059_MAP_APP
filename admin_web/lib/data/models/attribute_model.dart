class AttributeModel {
  String? id;
  String name; // ví dụ: Màu sắc, Kích thước
  List<String> values; // ví dụ: ['Đỏ', 'Xanh'], ['S', 'M', 'L']

  AttributeModel({this.id, required this.name, required this.values});

  Map<String, dynamic> toJson() => {
    'name': name,
    'values': values,
  };

  factory AttributeModel.fromJson(Map<String, dynamic> json, String docId) => AttributeModel(
    id: docId,
    name: json['name'] ?? '',
    values: List<String>.from(json['values'] ?? []),
  );
}
