import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attribute_model.dart';

class AttributeService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('attributes');

  Future<List<AttributeModel>> getAttributes() async {
    QuerySnapshot snapshot = await _collection.get();
    return snapshot.docs.map((doc) => AttributeModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}
