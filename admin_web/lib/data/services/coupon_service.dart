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

  Future<void> updateCoupon(CouponModel coupon) async {
    await _collection.doc(coupon.id).update(coupon.toJson());
  }

  Future<void> deleteCoupon(String id) async {
    await _collection.doc(id).delete();
  }
}
