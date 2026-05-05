import 'package:flutter/material.dart';
import '../../data/models/shipping_address_model.dart';

class ShippingAddressScreen extends StatefulWidget {
  final List<ShippingAddress> addresses;

  const ShippingAddressScreen({
    super.key,
    required this.addresses,
  });

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  late List<ShippingAddress> addressList;

  @override
  void initState() {
    super.initState();
    addressList = List.from(widget.addresses);
  }

  void _editAddress(ShippingAddress address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(
          address: address,
          onSave: (updatedAddress) {
            setState(() {
              final index = addressList.indexWhere((a) => a.id == address.id);
              if (index >= 0) {
                addressList[index] = updatedAddress;
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteAddress(ShippingAddress address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa địa chỉ'),
        content: const Text('Bạn có chắc chắn muốn xóa địa chỉ này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                addressList.removeWhere((a) => a.id == address.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa địa chỉ'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _setDefault(ShippingAddress address) {
    setState(() {
      for (var addr in addressList) {
        addr = addr.copyWith(isDefault: addr.id == address.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Địa chỉ giao hàng',
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
          Expanded(
            child: addressList.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: addressList.length,
                    itemBuilder: (context, index) {
                      return _buildAddressCard(context, addressList[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditAddressScreen(
                onSave: (newAddress) {
                  setState(() {
                    addressList.add(newAddress);
                  });
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Chưa có địa chỉ nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Thêm địa chỉ giao hàng đầu tiên của bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, ShippingAddress address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Divider(height: 1, color: Colors.grey[200]),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _editAddress(address),
                  child: const Text(
                    'Sửa',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
              VerticalDivider(width: 1, color: Colors.grey[200]),
              Expanded(
                child: TextButton(
                  onPressed: () => _deleteAddress(address),
                  child: const Text(
                    'Xóa',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              if (!address.isDefault) ...[
                VerticalDivider(width: 1, color: Colors.grey[200]),
                Expanded(
                  child: TextButton(
                    onPressed: () => _setDefault(address),
                    child: const Text(
                      'Đặt mặc định',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class AddEditAddressScreen extends StatefulWidget {
  final ShippingAddress? address;
  final Function(ShippingAddress) onSave;

  const AddEditAddressScreen({
    super.key,
    this.address,
    required this.onSave,
  });

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  late TextEditingController recipientNameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController wardController;
  late TextEditingController districtController;
  late TextEditingController provinceController;
  late TextEditingController postalCodeController;

  @override
  void initState() {
    super.initState();
    recipientNameController =
        TextEditingController(text: widget.address?.recipientName ?? '');
    phoneController =
        TextEditingController(text: widget.address?.phoneNumber ?? '');
    addressController =
        TextEditingController(text: widget.address?.address ?? '');
    wardController = TextEditingController(text: widget.address?.ward ?? '');
    districtController =
        TextEditingController(text: widget.address?.district ?? '');
    provinceController =
        TextEditingController(text: widget.address?.province ?? '');
    postalCodeController =
        TextEditingController(text: widget.address?.postalCode ?? '');
  }

  @override
  void dispose() {
    recipientNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    wardController.dispose();
    districtController.dispose();
    provinceController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (recipientNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final address = ShippingAddress(
      id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.address?.userId ?? 'user1',
      recipientName: recipientNameController.text,
      phoneNumber: phoneController.text,
      address: addressController.text,
      ward: wardController.text,
      district: districtController.text,
      province: provinceController.text,
      postalCode: postalCodeController.text,
      isDefault: widget.address?.isDefault ?? false,
    );

    widget.onSave(address);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.address == null ? 'Địa chỉ đã được thêm' : 'Địa chỉ đã được cập nhật',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          widget.address == null ? 'Thêm địa chỉ' : 'Sửa địa chỉ',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Tên người nhận',
              controller: recipientNameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Số điện thoại',
              controller: phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Địa chỉ chi tiết',
              controller: addressController,
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Phường/Xã',
              controller: wardController,
              icon: Icons.domain_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Quận/Huyện',
              controller: districtController,
              icon: Icons.domain_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Tỉnh/Thành phố',
              controller: provinceController,
              icon: Icons.domain_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Mã bưu chính',
              controller: postalCodeController,
              icon: Icons.mail_outline,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.address == null ? 'Thêm địa chỉ' : 'Cập nhật',
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
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(icon, color: Colors.brown),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.brown, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
