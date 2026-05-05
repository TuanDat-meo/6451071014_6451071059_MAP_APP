import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/models/boba_model.dart';

class WishlistController extends GetxController {
  var wishlistItems = <BobaModel>[].obs;
  var wishlistIds = <String>[].obs;

  final DatabaseReference _wishlistRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://vs6451071059-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref().child('wishlists');

  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';

  @override
  void onInit() {
    super.onInit();
    _loadWishlist();
  }

  void _loadWishlist() {
    _wishlistRef.child(_userId).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        wishlistItems.clear();
        wishlistIds.clear();
        return;
      }

      final List<BobaModel> items = [];
      final List<String> ids = [];

      data.forEach((key, value) {
        final map = value as Map<dynamic, dynamic>;
        final productId = (map['productId'] ?? key).toString();
        items.add(BobaModel.fromJson(map, productId));
        ids.add(productId);
      });

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
      await _wishlistRef.child(_userId).child(productId).set({
        'productId': productId,
        'name': product.name,
        'price': product.price,
        'image': product.image,
        'description': product.description,
        'category': product.category,
        'addedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Lỗi thêm wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      await _wishlistRef.child(_userId).child(productId).remove();
    } catch (e) {
      print('Lỗi xóa wishlist: $e');
    }
  }

  Future<void> clearWishlist() async {
    try {
      await _wishlistRef.child(_userId).remove();
    } catch (e) {
      print('Lỗi xóa tất cả wishlist: $e');
    }
  }
}
