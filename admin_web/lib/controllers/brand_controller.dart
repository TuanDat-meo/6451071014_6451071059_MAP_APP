import 'package:get/get.dart';
import '../data/models/brand_model.dart';
import '../data/services/brand_service.dart';

class BrandController extends GetxController {
  final BrandService _service = BrandService();
  var brands = <BrandModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedIds = <String>{}.obs;

  List<BrandModel> get filteredBrands {
    if (searchQuery.isEmpty) return brands;
    final query = searchQuery.value.toLowerCase();
    return brands.where((b) => b.name.toLowerCase().contains(query)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () => fetchBrands());
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


  void fetchBrands() async {
    try {
      isLoading.value = true;
      brands.value = await _service.getBrands();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addBrand(String name, bool isFeatured) async {
    await _service.addBrand(BrandModel(name: name, isFeatured: isFeatured));
    fetchBrands();
  }

  Future<void> updateBrand(String id, String name, bool isFeatured) async {
    await _service.updateBrand(BrandModel(id: id, name: name, isFeatured: isFeatured));
    fetchBrands();
  }

  Future<void> deleteBrand(String id) async {
    await _service.deleteBrand(id);
    fetchBrands();
  }
}


