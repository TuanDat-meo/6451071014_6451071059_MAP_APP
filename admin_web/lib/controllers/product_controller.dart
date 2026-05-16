import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _service = ProductService();
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedIds = <String>{}.obs;

  List<ProductModel> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    return products.where((p) => p.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () => fetchProducts());
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


  void fetchProducts() async {
    try {
      isLoading.value = true;
      products.value = await _service.getProducts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await _service.addProduct(product);
    fetchProducts();
  }

  Future<void> updateProduct(ProductModel product) async {
    await _service.updateProduct(product);
    fetchProducts();
  }

  Future<void> deleteProduct(String id) async {
    await _service.deleteProduct(id);
    fetchProducts();
  }
}

