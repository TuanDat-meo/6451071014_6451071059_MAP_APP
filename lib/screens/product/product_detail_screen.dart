import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/boba_model.dart';
import '../../data/models/cart_item_model.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import '../../controller/cart_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final BobaModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late int quantity = 1;
  late String selectedSize = 'M';
  late List<String> selectedToppings = [];
  late double additionalPrice = 0;

  // Size pricing
  final Map<String, double> sizePrices = {
    'M': 0,
    'L': 10000,
    'XL': 20000,
  };

  // Toppings available
  final List<Map<String, dynamic>> availableToppings = [
    {'name': 'Trân châu đường đen', 'price': 8000, 'selected': false},
    {'name': 'Trân châu trắng', 'price': 8000, 'selected': false},
    {'name': 'Jelly dâu', 'price': 5000, 'selected': false},
    {'name': 'Nước cốt dừa', 'price': 5000, 'selected': false},
    {'name': 'Thạch cà phê', 'price': 6000, 'selected': false},
    {'name': 'Kem tươi', 'price': 10000, 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    _calculateAdditionalPrice();
  }

  void _calculateAdditionalPrice() {
    double price = sizePrices[selectedSize] ?? 0;
    for (var topping in selectedToppings) {
      final toppingData = availableToppings.firstWhere(
        (t) => t['name'] == topping,
        orElse: () => {'price': 0},
      );
      price += (toppingData['price'] as num).toDouble();
    }
    setState(() {
      additionalPrice = price;
    });
  }

  void _toggleTopping(String toppingName) {
    setState(() {
      if (selectedToppings.contains(toppingName)) {
        selectedToppings.remove(toppingName);
      } else {
        selectedToppings.add(toppingName);
      }
      _calculateAdditionalPrice();
    });
  }

  void _addToCart() {
    final cartItem = CartItem(
      id: const Uuid().v4(),
      product: widget.product,
      quantity: quantity,
      size: selectedSize,
      toppings: selectedToppings,
      additionalPrice: additionalPrice,
    );

    // Lấy CartController và thêm sản phẩm
    final cartController = Get.find<CartController>();
    cartController.addToCart(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${widget.product.name} vào giỏ hàng!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.brown,
      ),
    );

    Navigator.pop(context, cartItem);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
              child: Image.asset(
                widget.product.image,
                fit: BoxFit.cover,
              ),
            ),

            // Product Info
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.product.category,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.brown,
                          size: 28,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã thêm vào yêu thích!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    currencyFormat.format(
                      widget.product.price + additionalPrice,
                    ),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Description
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Size Selection
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn kích cỡ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['M', 'L', 'XL']
                        .map((size) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = size;
                                  _calculateAdditionalPrice();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedSize == size
                                      ? Colors.brown
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      size,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: selectedSize == size
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '+${currencyFormat.format(widget.product.price + sizePrices[size]!)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: selectedSize == size
                                            ? Colors.white
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Toppings Selection
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn topping (tùy chọn)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: availableToppings
                        .map((topping) => GestureDetector(
                              onTap: () => _toggleTopping(topping['name']),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedToppings
                                          .contains(topping['name'])
                                      ? Colors.brown
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.brown,
                                    width: selectedToppings
                                            .contains(topping['name'])
                                        ? 2
                                        : 1,
                                  ),
                                ),
                                child: Text(
                                  '${topping['name']} (+${currencyFormat.format(topping['price'])})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: selectedToppings
                                            .contains(topping['name'])
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Quantity Selection
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Số lượng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: quantity > 1
                              ? () => setState(() => quantity--)
                              : null,
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '$quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => quantity++),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Thêm vào giỏ hàng  +  ${currencyFormat.format((widget.product.price + additionalPrice) * quantity)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
