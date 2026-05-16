import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/brand_model.dart';

class BrandService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('brands');

  Future<List<BrandModel>> getBrands() async {
    QuerySnapshot snapshot = await _collection.get();
    return snapshot.docs.map((doc) => BrandModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> addBrand(BrandModel brand) async {
    await _collection.add(brand.toJson());
  }

  Future<void> updateBrand(BrandModel brand) async {
    await _collection.doc(brand.id).update(brand.toJson());
  }

  Future<void> deleteBrand(String id) async {
    await _collection.doc(id).delete();
  }
}

