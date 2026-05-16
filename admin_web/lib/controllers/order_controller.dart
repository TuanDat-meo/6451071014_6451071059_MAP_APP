import 'package:get/get.dart';
import '../data/models/order_model.dart';
import '../data/services/order_service.dart';

class OrderController extends GetxController {
  final OrderService _service = OrderService();
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedIds = <String>{}.obs;

  List<OrderModel> get filteredOrders {
    if (searchQuery.isEmpty) return orders;
    final query = searchQuery.value.toLowerCase();
    return orders.where((o) => 
      (o.id?.toLowerCase().contains(query) ?? false) || 
      o.customerName.toLowerCase().contains(query)
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () => fetchOrders());
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


  void fetchOrders() async {
    try {
      isLoading.value = true;
      orders.value = await _service.getOrders();
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatus(String orderId, String status) async {
    await _service.updateOrderStatus(orderId, status);
    fetchOrders();
  }
}

