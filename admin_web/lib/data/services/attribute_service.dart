import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attribute_model.dart';

class AttributeService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('attributes');

  Future<List<AttributeModel>> getAttributes() async {
    QuerySnapshot snapshot = await _collection.get();
    return snapshot.docs.map((doc) => AttributeModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> addAttribute(AttributeModel attr) async {
    await _collection.add(attr.toJson());
  }

  Future<void> updateAttribute(AttributeModel attr) async {
    await _collection.doc(attr.id).update(attr.toJson());
  }

  Future<void> deleteAttribute(String id) async {
    await _collection.doc(id).delete();
  }
}

