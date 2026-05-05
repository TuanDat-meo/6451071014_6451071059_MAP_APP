import 'package:flutter/material.dart';
import '../../data/models/shipping_address_model.dart';
import '../../data/services/firebase_service.dart';
import '../../common/theme/app_theme.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Địa chỉ giao hàng',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.darkBrown, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<ShippingAddress>>(
        stream: firebaseService.getShippingAddressesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.milkTea));
          }

          final addresses = snapshot.data ?? [];

          if (addresses.isEmpty) {
            return _buildEmptyState(context, firebaseService);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return _buildAddressCard(context, addresses[index], firebaseService);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddEditAddressScreen(
              onSave: (addr) => firebaseService.addShippingAddress(addr),
            ),
          ));
        },
        backgroundColor: AppColors.milkTea,
        icon: const Icon(Icons.add_rounded, color: AppColors.white),
        label: const Text('Thêm địa chỉ', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, FirebaseService service) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(color: AppColors.tapioca.withOpacity(0.3), shape: BoxShape.circle),
            child: const Icon(Icons.location_on_outlined, size: 48, color: AppColors.milkTea),
          ),
          const SizedBox(height: 24),
          const Text('Chưa có địa chỉ nào',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
          const SizedBox(height: 8),
          Text('Thêm địa chỉ giao hàng đầu tiên của bạn',
              style: TextStyle(fontSize: 14, color: AppColors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => AddEditAddressScreen(
                  onSave: (addr) => service.addShippingAddress(addr),
                ),
              ));
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Thêm địa chỉ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.milkTea, foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, ShippingAddress address, FirebaseService service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: address.isDefault ? Border.all(color: AppColors.milkTea, width: 1.5) : null,
        boxShadow: [BoxShadow(color: AppColors.darkBrown.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.milkTea.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.location_on_rounded,
                          color: address.isDefault ? AppColors.milkTea : AppColors.grey, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(address.recipientName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              if (address.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.milkTea,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Mặc định',
                                      style: TextStyle(fontSize: 10, color: AppColors.white, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(address.phoneNumber, style: TextStyle(fontSize: 13, color: AppColors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(address.getFullAddress(),
                    style: TextStyle(fontSize: 13, color: AppColors.darkGrey, height: 1.4),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.tapioca.withOpacity(0.5)),
          // Action buttons
          IntrinsicHeight(
            child: Row(
              children: [
                _buildActionBtn('Sửa', Icons.edit_outlined, AppColors.milkTea, () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AddEditAddressScreen(
                      address: address,
                      onSave: (updated) => service.updateShippingAddress(updated),
                    ),
                  ));
                }),
                VerticalDivider(width: 1, color: AppColors.tapioca.withOpacity(0.5)),
                _buildActionBtn('Xóa', Icons.delete_outline, AppColors.rose, () {
                  _showDeleteDialog(context, address, service);
                }),
                if (!address.isDefault) ...[
                  VerticalDivider(width: 1, color: AppColors.tapioca.withOpacity(0.5)),
                  _buildActionBtn('Đặt mặc định', Icons.check_circle_outline, AppColors.matcha, () {
                    service.setDefaultAddress(address.id);
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: color),
        label: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ShippingAddress address, FirebaseService service) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa địa chỉ'),
        content: Text('Bạn có chắc chắn muốn xóa địa chỉ của "${address.recipientName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              service.deleteShippingAddress(address.id);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ============== ADD/EDIT ADDRESS SCREEN ==============

class AddEditAddressScreen extends StatefulWidget {
  final ShippingAddress? address;
  final Function(ShippingAddress) onSave;

  const AddEditAddressScreen({super.key, this.address, required this.onSave});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _wardCtrl;
  late TextEditingController _districtCtrl;
  late TextEditingController _provinceCtrl;
  late TextEditingController _postalCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.address?.recipientName ?? '');
    _phoneCtrl = TextEditingController(text: widget.address?.phoneNumber ?? '');
    _addressCtrl = TextEditingController(text: widget.address?.address ?? '');
    _wardCtrl = TextEditingController(text: widget.address?.ward ?? '');
    _districtCtrl = TextEditingController(text: widget.address?.district ?? '');
    _provinceCtrl = TextEditingController(text: widget.address?.province ?? '');
    _postalCtrl = TextEditingController(text: widget.address?.postalCode ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose(); _addressCtrl.dispose();
    _wardCtrl.dispose(); _districtCtrl.dispose(); _provinceCtrl.dispose(); _postalCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final addr = ShippingAddress(
      id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.address?.userId ?? 'user1',
      recipientName: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      ward: _wardCtrl.text.trim(),
      district: _districtCtrl.text.trim(),
      province: _provinceCtrl.text.trim(),
      postalCode: _postalCtrl.text.trim(),
      isDefault: widget.address?.isDefault ?? false,
    );

    widget.onSave(addr);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(widget.address == null ? 'Đã thêm địa chỉ!' : 'Đã cập nhật!'),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text(isEdit ? 'Sửa địa chỉ' : 'Thêm địa chỉ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.darkBrown, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_nameCtrl, 'Tên người nhận', Icons.person_outline,
                  validator: (v) => v!.isEmpty ? 'Vui lòng nhập tên' : null),
              const SizedBox(height: 14),
              _field(_phoneCtrl, 'Số điện thoại', Icons.phone_outlined,
                  keyboard: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'Vui lòng nhập SĐT' : null),
              const SizedBox(height: 14),
              _field(_addressCtrl, 'Địa chỉ chi tiết', Icons.location_on_outlined, maxLines: 2,
                  validator: (v) => v!.isEmpty ? 'Vui lòng nhập địa chỉ' : null),
              const SizedBox(height: 14),
              _field(_wardCtrl, 'Phường/Xã', Icons.domain_outlined),
              const SizedBox(height: 14),
              _field(_districtCtrl, 'Quận/Huyện', Icons.domain_outlined),
              const SizedBox(height: 14),
              _field(_provinceCtrl, 'Tỉnh/Thành phố', Icons.location_city_outlined),
              const SizedBox(height: 14),
              _field(_postalCtrl, 'Mã bưu chính', Icons.mail_outline),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.milkTea,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(isEdit ? 'Cập nhật' : 'Thêm địa chỉ',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {
    TextInputType keyboard = TextInputType.text, int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl, keyboardType: keyboard, maxLines: maxLines, validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.milkTea, size: 20),
        filled: true, fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.tapioca)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.tapioca)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.milkTea, width: 2)),
      ),
    );
  }
}
