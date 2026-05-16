import 'package:get/get.dart';
import '../data/models/coupon_model.dart';
import '../data/services/coupon_service.dart';

class CouponController extends GetxController {
  final CouponService _service = CouponService();
  var coupons = <CouponModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedIds = <String>{}.obs;

  List<CouponModel> get filteredCoupons {
    if (searchQuery.isEmpty) return coupons;
    final query = searchQuery.value.toLowerCase();
    return coupons.where((c) => c.code.toLowerCase().contains(query)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () => fetchCoupons());
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    selectedIds.refresh();
  }


  void fetchCoupons() async {
    try {
      isLoading.value = true;
      coupons.value = await _service.getCoupons();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCoupon(CouponModel coupon) async {
    await _service.addCoupon(coupon);
    fetchCoupons();
  }

  Future<void> updateCoupon(CouponModel coupon) async {
    await _service.updateCoupon(coupon);
    fetchCoupons();
  }

  Future<void> deleteCoupon(String id) async {
    await _service.deleteCoupon(id);
    fetchCoupons();
  }
}

