import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot snapshot = await _productCollection.get();
    return snapshot.docs.map((doc) {
      return ProductModel.fromJson(doc.data() as Map<String, dynamic>)..id = doc.id;
    }).toList();
  }

  Future<void> addProduct(ProductModel product) async {
    await _productCollection.add(product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productCollection.doc(product.id).update(product.toJson());
  }

  Future<void> deleteProduct(String id) async {
    await _productCollection.doc(id).delete();
  }
}
