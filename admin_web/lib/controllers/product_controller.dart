import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _service = ProductService();
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;
      // products.value = await _service.getProducts();
    } finally {
      isLoading.value = false;
    }
  }
}
