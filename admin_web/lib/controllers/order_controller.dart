import 'package:get/get.dart';
import '../data/models/order_model.dart';
import '../data/services/order_service.dart';

class OrderController extends GetxController {
  final OrderService _service = OrderService();
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
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
