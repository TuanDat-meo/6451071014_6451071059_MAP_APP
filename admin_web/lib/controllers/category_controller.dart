import 'package:get/get.dart';
import '../data/models/category_model.dart';
import '../data/services/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService _service = CategoryService();
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedIds = <String>{}.obs;

  List<CategoryModel> get filteredCategories {
    if (searchQuery.isEmpty) return categories;
    return categories.where((c) => c.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () => fetchCategories());
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

  void clearSelection() {
    selectedIds.clear();
    selectedIds.refresh();
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

  Future<void> updateCategory(CategoryModel category) async {
    await _service.updateCategory(category);
    fetchCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _service.deleteCategory(id);
    fetchCategories();
  }
}

