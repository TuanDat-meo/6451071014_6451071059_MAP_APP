import 'package:get/get.dart';
import '../data/models/customer_model.dart';
import '../data/services/customer_service.dart';

class CustomerController extends GetxController {
  final CustomerService _service = CustomerService();
  var customers = <CustomerModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedIds = <String>{}.obs;

  List<CustomerModel> get filteredCustomers {
    if (searchQuery.isEmpty) return customers;
    final query = searchQuery.value.toLowerCase();
    return customers.where((c) => 
      c.fullName.toLowerCase().contains(query) || 
      c.email.toLowerCase().contains(query) ||
      (c.phoneNumber?.toLowerCase().contains(query) ?? false)
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () => fetchCustomers());
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


  void fetchCustomers() async {
    try {
      isLoading.value = true;
      customers.value = await _service.getCustomers();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    await _service.updateCustomer(customer);
    fetchCustomers();
  }

  Future<void> deleteCustomer(String id) async {
    await _service.deleteCustomer(id);
    fetchCustomers();
  }
}

