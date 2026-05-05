import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/shipping_address_model.dart';

class CheckoutScreen extends StatefulWidget {
  final CartModel cart;

  const CheckoutScreen({
    super.key,
    required this.cart,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late PageController _pageController;
  int _currentStep = 0; // 0: Shipping, 1: Payment

  // Sample shipping addresses
  final List<ShippingAddress> shippingAddresses = [
    ShippingAddress(
      id: '1',
      userId: 'user1',
      recipientName: 'Nguyễn Văn A',
      phoneNumber: '0987654321',
      address: '123 Đường ABC',
      ward: 'Phường 1',
      district: 'Quận 1',
      province: 'TP. Hồ Chí Minh',
      postalCode: '70000',
      isDefault: true,
    ),
    ShippingAddress(
      id: '2',
      userId: 'user1',
      recipientName: 'Nguyễn Văn B',
      phoneNumber: '0912345678',
      address: '456 Đường XYZ',
      ward: 'Phường 2',
      district: 'Quận 2',
      province: 'TP. Hồ Chí Minh',
      postalCode: '70000',
      isDefault: false,
    ),
  ];

  ShippingAddress? selectedAddress;
  PaymentMethod selectedPaymentMethod = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    selectedAddress = shippingAddresses.firstWhere(
      (addr) => addr.isDefault,
      orElse: () => shippingAddresses.first,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOrder() {
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn địa chỉ giao hàng'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // TODO: Create order in Firebase
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user1',
      items: widget.cart.items,
      subtotal: widget.cart.getSubtotal(),
      shippingCost: widget.cart.shippingCost,
      taxCost: widget.cart.taxCost,
      discountCost: widget.cart.discountCost,
      totalAmount: widget.cart.getTotalPrice(),
      shippingAddressId: selectedAddress!.id,
      recipientName: selectedAddress!.recipientName,
      recipientPhone: selectedAddress!.phoneNumber,
      shippingAddress: selectedAddress!.getFullAddress(),
      paymentMethod: selectedPaymentMethod,
    );

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Đơn hàng thành công!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã đơn hàng: ${order.id}'),
            const SizedBox(height: 10),
            const Text('Đơn hàng của bạn đã được tạo thành công.'),
            const SizedBox(height: 10),
            const Text('Bạn sẽ nhận được thông báo khi đơn hàng được xác nhận.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close checkout screen
              Navigator.pop(context); // Close cart screen
              // Navigate to order tracking
              Navigator.pushNamed(context, '/order-management', arguments: order.id);
            },
            child: const Text('Theo dõi đơn hàng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Step Indicator
          _buildStepIndicator(),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                // Step 1: Shipping Address
                _buildShippingStep(context),

                // Step 2: Payment Method
                _buildPaymentStep(context),
              ],
            ),
          ),

          // Order Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tóm tắt đơn hàng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tạm tính (${widget.cart.items.length} sản phẩm)',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      currencyFormat.format(widget.cart.getSubtotal()),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Phí vận chuyển',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      currencyFormat.format(widget.cart.shippingCost),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cộng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currencyFormat.format(widget.cart.getTotalPrice()),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _currentStep == 1 ? _completeOrder : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _currentStep == 1 ? Colors.brown : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep == 0 ? 'Tiếp tục' : 'Đặt hàng',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _goToStep(0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentStep >= 0 ? Colors.brown : Colors.grey[300],
                    ),
                    child: Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color:
                              _currentStep >= 0 ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Địa chỉ',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentStep >= 0 ? Colors.brown : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: Divider(
              color: _currentStep >= 1 ? Colors.brown : Colors.grey[300],
              thickness: 2,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _goToStep(1),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentStep >= 1 ? Colors.brown : Colors.grey[300],
                    ),
                    child: Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          color:
                              _currentStep >= 1 ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentStep >= 1 ? Colors.brown : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn địa chỉ giao hàng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            shippingAddresses.length,
            (index) => _buildAddressCard(shippingAddresses[index]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Navigate to add new address
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thêm địa chỉ mới'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.brown),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '+ Thêm địa chỉ mới',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _goToStep(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tiếp tục',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(ShippingAddress address) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddress = address;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selectedAddress?.id == address.id
                ? Colors.brown
                : Colors.grey[300]!,
            width: selectedAddress?.id == address.id ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.recipientName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address.phoneNumber,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Mặc định',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address.getFullAddress(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn phương thức thanh toán',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            PaymentMethod.values.length,
            (index) => _buildPaymentMethodCard(PaymentMethod.values[index]),
          ),
          const SizedBox(height: 24),
          const Text(
            'Thông tin giao hàng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giao đến:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedAddress?.recipientName ?? 'Chưa chọn',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedAddress?.getFullAddress() ?? 'Chưa chọn',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selectedPaymentMethod == method
                ? Colors.brown
                : Colors.grey[300]!,
            width: selectedPaymentMethod == method ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedPaymentMethod == method
                      ? Colors.brown
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: selectedPaymentMethod == method
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.brown,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.displayName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getPaymentMethodDescription(method),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPaymentMethodDescription(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Thanh toán khi nhận hàng';
      case PaymentMethod.bankTransfer:
        return 'Chuyển khoản ngân hàng';
      case PaymentMethod.creditCard:
        return 'Thanh toán bằng thẻ tín dụng';
      case PaymentMethod.wallet:
        return 'Thanh toán qua ví điện tử';
    }
  }
}
