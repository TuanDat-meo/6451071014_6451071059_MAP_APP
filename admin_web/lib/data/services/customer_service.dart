import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class CustomerService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('customers');

  Future<List<CustomerModel>> getCustomers() async {
    QuerySnapshot snapshot = await _collection.get();
    return snapshot.docs.map((doc) => CustomerModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    await _collection.doc(customer.id).update(customer.toJson());
  }
}
