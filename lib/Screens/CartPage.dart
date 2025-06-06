import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(
      id: '1',
      image: 'assets/images/ip_11.jpg',
      name: 'Winter Blazer',
      description: 'Size L, Blue',
      price: 1100000,
      quantity: 1,
    ),
    CartItem(
      id: '2',
      image: 'assets/images/ip_12.jpg',
      name: 'Classic Denim Jeans',
      description: 'Size L, Black',
      price: 1100000,
      quantity: 1,
    ),
  ];

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get tax => subtotal * 0.07; // 7% tax
  double get deliveryFee => 0.0;
  double get total => subtotal + tax + deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ກະຕ່າ'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder:
                  (context, index) => CartItemCard(
                    item: cartItems[index],
                    onQuantityChanged: (newQuantity) {
                      setState(() {
                        cartItems[index].quantity = newQuantity;
                      });
                    },
                    onRemove: () {
                      setState(() {
                        cartItems.removeAt(index);
                      });
                    },
                  ),
            ),
          ),
          OrderSummary(
            subtotal: subtotal,
            tax: tax,
            deliveryFee: deliveryFee,
            total: total,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _checkout(),
              child: const Text('ສັ່ງຊື້'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkout() async {
    // TODO: Implement checkout API call
    final orderData = {
      'items': cartItems.map((item) => item.toJson()).toList(),
      'total': total,
    };
    print('Order submitted: $orderData');
  }
}

class CartItem {
  final String id;
  final String image;
  final String name;
  final String description;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
  };
}

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final Function() onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(item.description),
                  Text(
                    '${NumberFormat('#,###').format(item.price)} ₭',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            QuantitySelector(
              quantity: item.quantity,
              onChanged: onQuantityChanged,
            ),
            IconButton(icon: const Icon(Icons.delete), onPressed: onRemove),
          ],
        ),
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
        ),
        Text(quantity.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged(quantity + 1),
        ),
      ],
    );
  }
}

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSummaryRow('ຍອດລວມ', subtotal),
          _buildSummaryRow('ພາສີ', tax),
          _buildSummaryRow('ຄ່າຈັດສົ່ງ', deliveryFee),
          const Divider(),
          _buildSummaryRow('ລວມທັງໝົດ', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    final formatCurrency = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 0,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${formatCurrency.format(value)} ₭',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    double subtotal = cartProvider.cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    double tax = subtotal * 0.07;
    double deliveryFee = 0.0;
    double total = subtotal + tax + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าสินค้า'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(child: Text('ไม่มีสินค้าที่เพิ่มในตะกร้า'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItems[index];
                      return CartItemCard(
                        item: item,
                        onQuantityChanged: (newQuantity) {
                          cartProvider.cartItems[index]['quantity'] = newQuantity;
                          cartProvider.notifyListeners();
                        },
                        onRemove: () {
                          cartProvider.removeFromCart(index);
                        },
                      );
                    },
                  ),
                ),
                OrderSummary(
                  subtotal: subtotal,
                  tax: tax,
                  deliveryFee: deliveryFee,
                  total: total,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => _checkout(context, cartProvider.cartItems, total),
                    child: const Text('สั่งซื้อ'),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _checkout(BuildContext context, List<Map<String, dynamic>> items, double total) async {
    final orderData = {
      'items': items,
      'total': total,
    };
    print('Order submitted: $orderData');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ทำการสั่งซื้อเรียบร้อยแล้ว')),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChanged;
  final Function() onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item['image'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: Theme.of(context).textTheme.titleMedium),
                  Text(item['description']),
                  Text('\$${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            QuantitySelector(
              quantity: item['quantity'],
              onChanged: onQuantityChanged,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
        ),
        Text(quantity.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged(quantity + 1),
        ),
      ],
    );
  }
}

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSummaryRow('ยอดรวม', subtotal),
          _buildSummaryRow('ภาษี', tax),
          _buildSummaryRow('ค่าจัดส่ง', deliveryFee),
          const Divider(),
          _buildSummaryRow('รวมทั้งหมด', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text('\$${value.toStringAsFixed(2)}',
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}*/
