class ProductReviewModel {
  String? id;
  String productId;
  String customerName;
  double rating;
  String comment;
  DateTime date;

  ProductReviewModel({
    this.id,
    required this.productId,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'customerName': customerName,
    'rating': rating,
    'comment': comment,
    'date': date.toIso8601String(),
  };

  factory ProductReviewModel.fromJson(Map<String, dynamic> json, String docId) => ProductReviewModel(
    id: docId,
    productId: json['productId'] ?? '',
    customerName: json['customerName'] ?? '',
    rating: (json['rating'] ?? 0).toDouble(),
    comment: json['comment'] ?? '',
    date: DateTime.parse(json['date']),
  );
}
