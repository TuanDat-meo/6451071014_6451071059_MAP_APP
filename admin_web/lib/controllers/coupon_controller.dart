import 'package:get/get.dart';
import '../data/models/coupon_model.dart';
import '../data/services/coupon_service.dart';

class CouponController extends GetxController {
  final CouponService _service = CouponService();
  var coupons = <CouponModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  void fetchCoupons() async {
    try {
      isLoading.value = true;
      // coupons.value = await _service.getCoupons();
    } finally {
      isLoading.value = false;
    }
  }
}
