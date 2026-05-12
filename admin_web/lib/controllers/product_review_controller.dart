import 'package:get/get.dart';
import '../data/models/product_review_model.dart';
import '../data/services/product_review_service.dart';

class ProductReviewController extends GetxController {
  final ProductReviewService _service = ProductReviewService();
  var reviews = <ProductReviewModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  void fetchReviews() async {
    try {
      isLoading.value = true;
      reviews.value = await _service.getReviews();
    } finally {
      isLoading.value = false;
    }
  }

  void deleteReview(String id) async {
    await _service.deleteReview(id);
    fetchReviews();
  }
}
