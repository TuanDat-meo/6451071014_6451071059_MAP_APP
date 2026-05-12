import 'package:get/get.dart';
import '../data/models/brand_model.dart';
import '../data/services/brand_service.dart';

class BrandController extends GetxController {
  final BrandService _service = BrandService();
  var brands = <BrandModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
  }

  void fetchBrands() async {
    try {
      isLoading.value = true;
      brands.value = await _service.getBrands();
    } finally {
      isLoading.value = false;
    }
  }
}
