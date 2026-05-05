import 'package:flutter/material.dart';
import '../../data/models/boba_model.dart';
import '../../data/services/firebase_service.dart';
import '../../common/theme/app_theme.dart';
import 'package:intl/intl.dart';
import '../product/product_detail_screen.dart';
import '../notifications/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Tất cả', 'icon': Icons.grid_view_rounded},
    {'label': 'Trà Sữa', 'icon': Icons.local_cafe_rounded},
    {'label': 'Trà Trái Cây', 'icon': Icons.emoji_food_beverage_rounded},
    {'label': 'Đá Xay', 'icon': Icons.icecream_rounded},
    {'label': 'Latte', 'icon': Icons.coffee_rounded},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BobaModel> _filterProducts(List<BobaModel> products) {
    var filtered = products;
    
    // Lọc theo danh mục
    if (_selectedCategory != 'Tất cả') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }
    
    // Lọc theo tìm kiếm
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q)).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Boba House',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown, fontSize: 22)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.darkBrown),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
            },
          ),
        ],
      ),
      body: StreamBuilder<List<BobaModel>>(
        stream: FirebaseService().getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.milkTea));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final allProducts = snapshot.data ?? [];
          final filteredProducts = _filterProducts(allProducts);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Welcome
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chào bạn quay trở lại! 👋',
                        style: TextStyle(fontSize: 14, color: AppColors.grey)),
                    const SizedBox(height: 4),
                    const Text('Hôm nay uống gì nào?',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.darkBrown.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm trà sữa...',
                      hintStyle: TextStyle(color: AppColors.grey.withOpacity(0.6), fontSize: 14),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.milkTea),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, color: AppColors.grey, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Category filter chips
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat['label'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat['label']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.milkTea : AppColors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isSelected ? AppColors.milkTea : AppColors.tapioca,
                            ),
                            boxShadow: isSelected
                                ? [BoxShadow(color: AppColors.milkTea.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 2))]
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(cat['icon'] as IconData,
                                  size: 16, color: isSelected ? AppColors.white : AppColors.grey),
                              const SizedBox(width: 6),
                              Text(cat['label'] as String,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? AppColors.white : AppColors.darkGrey,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // Product count + Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory == 'Tất cả' ? 'Thực đơn nổi bật' : _selectedCategory,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBrown),
                    ),
                    Text('${filteredProducts.length} món',
                        style: TextStyle(fontSize: 13, color: AppColors.grey)),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Product Grid
              Expanded(
                child: filteredProducts.isEmpty
                    ? _buildEmptySearch()
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(context, filteredProducts[index], currencyFormat);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: AppColors.tapioca),
          const SizedBox(height: 16),
          const Text('Không tìm thấy sản phẩm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
          const SizedBox(height: 8),
          Text('Thử tìm với từ khóa khác nhé!',
              style: TextStyle(fontSize: 14, color: AppColors.grey)),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, BobaModel product, NumberFormat format) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.darkBrown.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: product.image.startsWith('assets/')
                        ? Image.asset(product.image, fit: BoxFit.cover, width: double.infinity)
                        : Image.network(product.image, fit: BoxFit.cover, width: double.infinity,
                            errorBuilder: (c, e, s) => Container(
                              color: AppColors.tapioca.withOpacity(0.3),
                              child: const Center(child: Icon(Icons.local_cafe, size: 40, color: AppColors.milkTea)),
                            )),
                  ),
                  // Category badge
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.darkBrown.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(product.category,
                          style: const TextStyle(fontSize: 9, color: AppColors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),

            // Thông tin
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkBrown)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(format.format(product.price),
                          style: const TextStyle(color: AppColors.milkTea, fontWeight: FontWeight.bold, fontSize: 15)),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.milkTea,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add, color: AppColors.white, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
