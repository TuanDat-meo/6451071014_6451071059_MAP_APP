import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../controller/cart_controller.dart';
import '../../common/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import '../../data/services/firebase_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.find<CartController>();
  final _formKey = GlobalKey<FormState>();

  // Controllers cho các trường nhập
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  PaymentMethod _selectedPayment = PaymentMethod.cash;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = FirebaseService().userId;

      final newOrder = Order(
        id: const Uuid().v4(),
        userId: userId,
        items: List.from(cartController.cart.value.items),
        subtotal: cartController.subtotal,
        shippingCost: cartController.cart.value.shippingCost,
        taxCost: cartController.cart.value.taxCost,
        discountCost: cartController.cart.value.discountCost,
        totalAmount: cartController.total,
        shippingAddressId: 'checkout_address',
        recipientName: _nameController.text.trim(),
        recipientPhone: _phoneController.text.trim(),
        shippingAddress: _addressController.text.trim(),
        status: OrderStatus.pending,
        paymentMethod: _selectedPayment,
        notes: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      await FirebaseService().createOrder(newOrder);

      // Xóa giỏ hàng
      cartController.clearCart();

      // Chuyển sang tab đơn hàng trước
      cartController.changeTab(3);

      // Đóng checkout screen
      if (mounted) Navigator.pop(context);

      Get.snackbar(
        '🎉 Đặt hàng thành công!',
        'Đơn hàng #${newOrder.id.substring(0, 8)} đã được tiếp nhận.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể đặt hàng: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Xác nhận đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.darkBrown, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // === SECTION 1: Danh sách sản phẩm ===
                  _buildSection(
                    title: 'Sản phẩm đã chọn',
                    icon: Icons.shopping_bag_outlined,
                    child: Column(
                      children: cartController.cart.value.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(item.product.image,
                                    width: 56, height: 56, fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 56, height: 56,
                                      color: AppColors.tapioca.withOpacity(0.3),
                                      child: const Icon(Icons.local_cafe, color: AppColors.milkTea),
                                    )),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text('Size ${item.size} • x${item.quantity}',
                                        style: TextStyle(fontSize: 12, color: AppColors.grey)),
                                    if (item.toppings.isNotEmpty)
                                      Text('Topping: ${item.toppings.join(", ")}',
                                          style: TextStyle(fontSize: 11, color: AppColors.grey)),
                                  ],
                                ),
                              ),
                              Text(currencyFormat.format(item.getTotalPrice()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.milkTea)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // === SECTION 2: Thông tin giao hàng ===
                  _buildSection(
                    title: 'Thông tin giao hàng',
                    icon: Icons.local_shipping_outlined,
                    child: Column(
                      children: [
                        _buildFormField(
                          controller: _nameController,
                          label: 'Tên người nhận',
                          hint: 'Nguyễn Văn A',
                          icon: Icons.person_outline,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập tên' : null,
                        ),
                        const SizedBox(height: 14),
                        _buildFormField(
                          controller: _phoneController,
                          label: 'Số điện thoại',
                          hint: '0901234567',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Vui lòng nhập SĐT';
                            if (v.trim().length < 9) return 'SĐT không hợp lệ';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildFormField(
                          controller: _addressController,
                          label: 'Địa chỉ giao hàng',
                          hint: '123 Đường ABC, Quận 1, TP.HCM',
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập địa chỉ' : null,
                        ),
                        const SizedBox(height: 14),
                        _buildFormField(
                          controller: _noteController,
                          label: 'Ghi chú (tùy chọn)',
                          hint: 'Ít đường, nhiều đá...',
                          icon: Icons.note_outlined,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),

                  // === SECTION 3: Phương thức thanh toán ===
                  _buildSection(
                    title: 'Phương thức thanh toán',
                    icon: Icons.payment_outlined,
                    child: Column(
                      children: PaymentMethod.values.map((method) {
                        final isSelected = _selectedPayment == method;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedPayment = method),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.milkTea.withOpacity(0.1) : AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.milkTea : AppColors.tapioca,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(_getPaymentIcon(method),
                                    color: isSelected ? AppColors.milkTea : AppColors.grey, size: 24),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(method.displayName,
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? AppColors.darkBrown : AppColors.darkGrey,
                                      )),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.milkTea, size: 22),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // === SECTION 4: Tóm tắt chi phí ===
                  _buildSection(
                    title: 'Tóm tắt đơn hàng',
                    icon: Icons.receipt_long_outlined,
                    child: Column(
                      children: [
                        _buildPriceRow('Tạm tính (${cartController.itemCount} món)',
                            currencyFormat.format(cartController.subtotal)),
                        _buildPriceRow('Phí vận chuyển',
                            currencyFormat.format(cartController.cart.value.shippingCost)),
                        if (cartController.cart.value.discountCost > 0)
                          _buildPriceRow('Giảm giá',
                              '-${currencyFormat.format(cartController.cart.value.discountCost)}',
                              color: AppColors.matcha),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('TỔNG CỘNG',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
                            Text(currencyFormat.format(cartController.total),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.milkTea)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // === BOTTOM: Nút Đặt hàng ===
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(color: AppColors.darkBrown.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4)),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.milkTea,
                      disabledBackgroundColor: AppColors.tapioca,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24, height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.white))
                        : Text('ĐẶT HÀNG • ${currencyFormat.format(cartController.total)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.darkBrown.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.milkTea, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: AppColors.darkBrown),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.milkTea, size: 20),
        filled: true,
        fillColor: AppColors.offWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.tapioca)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.tapioca)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.milkTea, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.rose)),
        labelStyle: TextStyle(color: AppColors.grey, fontSize: 13),
        hintStyle: TextStyle(color: AppColors.grey.withOpacity(0.5), fontSize: 13),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: AppColors.darkGrey)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color ?? AppColors.darkBrown)),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money_rounded;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance_rounded;
      case PaymentMethod.creditCard:
        return Icons.credit_card_rounded;
      case PaymentMethod.wallet:
        return Icons.account_balance_wallet_rounded;
    }
  }
}
