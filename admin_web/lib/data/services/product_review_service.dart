import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_review_model.dart';

class ProductReviewService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('product_reviews');

  Future<List<ProductReviewModel>> getReviews() async {
    QuerySnapshot snapshot = await _collection.get();
    return snapshot.docs.map((doc) => ProductReviewModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> deleteReview(String id) async {
    await _collection.doc(id).delete();
  }
}
