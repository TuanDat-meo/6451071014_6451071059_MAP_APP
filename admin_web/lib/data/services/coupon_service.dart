import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coupon_model.dart';

class CouponService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('coupons');

  Future<List<CouponModel>> getCoupons() async {
    QuerySnapshot snapshot = await _collection.get();
    return snapshot.docs.map((doc) => CouponModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> addCoupon(CouponModel coupon) async {
    await _collection.add(coupon.toJson());
  }
}
