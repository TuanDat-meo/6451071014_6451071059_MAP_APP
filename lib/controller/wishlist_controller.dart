import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/boba_model.dart';
import '../data/services/firebase_service.dart';

class WishlistController extends GetxController {
  var wishlistItems = <BobaModel>[].obs;
  var wishlistIds = <String>[].obs;

  final CollectionReference _wishlistCol =
      FirebaseFirestore.instance.collection('wishlists');

  String get _userId => FirebaseService().userId;

  @override
  void onInit() {
    super.onInit();
    _loadWishlist();
  }

  void _loadWishlist() {
    _wishlistCol
        .where('userId', isEqualTo: _userId)
        .snapshots()
        .listen((snapshot) {
      final List<BobaModel> items = [];
      final List<String> ids = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final productId = data['productId'] ?? doc.id;
        items.add(BobaModel.fromJson(Map<dynamic, dynamic>.from(data), productId));
        ids.add(productId);
      }

      wishlistItems.value = items;
      wishlistIds.value = ids;
    });
  }

  bool isWishlisted(String productId) {
    return wishlistIds.contains(productId);
  }

  Future<void> toggleWishlist(BobaModel product) async {
    final productId = product.id ?? '';
    if (productId.isEmpty) return;

    if (isWishlisted(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(product);
    }
  }

  Future<void> addToWishlist(BobaModel product) async {
    try {
      final productId = product.id ?? '';
      await _wishlistCol.doc(productId).set({
        'userId': _userId,
        'productId': productId,
        'name': product.name,
        'price': product.price,
        'image': product.image,
        'description': product.description,
        'category': product.category,
        'addedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Lỗi thêm wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      await _wishlistCol.doc(productId).delete();
    } catch (e) {
      print('Lỗi xóa wishlist: $e');
    }
  }

  Future<void> clearWishlist() async {
    try {
      final snapshot = await _wishlistCol.where('userId', isEqualTo: _userId).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Lỗi xóa tất cả wishlist: $e');
    }
  }
}
