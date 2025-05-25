import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(
      id: '1',
      image: 'assets/images/item--1.png',
      name: 'Winter Blazer',
      description: 'Size L, Blue',
      price: 96.47,
      quantity: 1,
    ),
    CartItem(
      id: '2',
      image: 'assets/images/itemn--2.png',
      name: 'Classic Denim Jeans',
      description: 'Size L, Black',
      price: 58.47,
      quantity: 1,
    ),
    CartItem(
      id: '3',
      image: 'assets/images/itemn--2.png',
      name: 'Classic Denim Jeans',
      description: 'Size L, Black',
      price: 58.47,
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
        title: const Text('ຕະກ້າສິນຄ້າ'),
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
              child: const Text('ກົດສັ່ງຊື້'),
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
                    '\$${item.price.toStringAsFixed(2)}',
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
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
