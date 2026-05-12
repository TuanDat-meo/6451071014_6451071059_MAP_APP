import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection('orders');

  Future<List<OrderModel>> getOrders() async {
    QuerySnapshot snapshot = await _orderCollection.get();
    return snapshot.docs.map((doc) {
      return OrderModel.fromJson(doc.data() as Map<String, dynamic>)..id = doc.id;
    }).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _orderCollection.doc(orderId).update({'status': status});
  }
}
