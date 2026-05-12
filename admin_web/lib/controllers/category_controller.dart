import 'package:get/get.dart';
import '../data/models/category_model.dart';
import '../data/services/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService _service = CategoryService();
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading.value = true;
      categories.value = await _service.getCategories();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    await _service.addCategory(category);
    fetchCategories();
  }
}
