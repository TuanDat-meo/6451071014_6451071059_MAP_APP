import 'package:get/get.dart';
import '../data/models/attribute_model.dart';
import '../data/services/attribute_service.dart';

class AttributeController extends GetxController {
  final AttributeService _service = AttributeService();
  var attributes = <AttributeModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttributes();
  }

  void fetchAttributes() async {
    try {
      isLoading.value = true;
      attributes.value = await _service.getAttributes();
    } finally {
      isLoading.value = false;
    }
  }
}
