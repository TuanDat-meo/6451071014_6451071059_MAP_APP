import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  Future<List<CategoryModel>> getCategories() async {
    QuerySnapshot snapshot = await _categoryCollection.get();
    return snapshot.docs.map((doc) {
      return CategoryModel.fromJson(doc.data() as Map<String, dynamic>)..id = doc.id;
    }).toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _categoryCollection.add(category.toJson());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _categoryCollection.doc(category.id).update(category.toJson());
  }

  Future<void> deleteCategory(String id) async {
    await _categoryCollection.doc(id).delete();
  }
}
