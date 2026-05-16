import 'package:get/get.dart';
import '../data/models/attribute_model.dart';
import '../data/services/attribute_service.dart';

class AttributeController extends GetxController {
  final AttributeService _service = AttributeService();
  var attributes = <AttributeModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedIds = <String>{}.obs;

  List<AttributeModel> get filteredAttributes {
    if (searchQuery.isEmpty) return attributes;
    final query = searchQuery.value.toLowerCase();
    return attributes.where((a) => a.name.toLowerCase().contains(query)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () => fetchAttributes());
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


  void fetchAttributes() async {
    try {
      isLoading.value = true;
      attributes.value = await _service.getAttributes();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAttribute(String name, List<String> values) async {
    await _service.addAttribute(AttributeModel(name: name, values: values));
    fetchAttributes();
  }

  Future<void> updateAttribute(String id, String name, List<String> values) async {
    await _service.updateAttribute(AttributeModel(id: id, name: name, values: values));
    fetchAttributes();
  }

  Future<void> deleteAttribute(String id) async {
    await _service.deleteAttribute(id);
    fetchAttributes();
  }
}


