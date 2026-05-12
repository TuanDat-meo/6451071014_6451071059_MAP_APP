import 'package:get/get.dart';
import '../data/models/customer_model.dart';
import '../data/services/customer_service.dart';

class CustomerController extends GetxController {
  final CustomerService _service = CustomerService();
  var customers = <CustomerModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  void fetchCustomers() async {
    try {
      isLoading.value = true;
      customers.value = await _service.getCustomers();
    } finally {
      isLoading.value = false;
    }
  }
}
