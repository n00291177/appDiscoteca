import 'package:flutter/material.dart';
import 'package:nina_app/screens/payment_screen.dart';

class Product {
  final String name;
  final String category;
  final double price;

  Product({required this.name, required this.category, required this.price});
}

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final List<Product> _products = [
    Product(name: 'JOHNNIE WALKER Red Label', category: 'Whisky', price: 140.0),
    Product(name: 'JOHNNIE WALKER Black Label', category: 'Whisky', price: 220.0),
    Product(name: 'JOHNNIE WALKER Double Black', category: 'Whisky', price: 280.0),
    Product(name: 'JOHNNIE WALKER Gold Label', category: 'Whisky', price: 500.0),
    Product(name: 'JOHNNIE WALKER Green Label', category: 'Whisky', price: 700.0),
    Product(name: 'JOHNNIE WALKER Blue Label', category: 'Whisky', price: 2000.0),
    Product(name: 'JOHNNIE WALKER King George', category: 'Whisky', price: 5000.0),
    Product(name: 'CHIVAS 12 años', category: 'Whisky', price: 220.0),
    Product(name: 'CHIVAS 15 años', category: 'Whisky', price: 320.0),
    Product(name: 'CHIVAS 18 años', category: 'Whisky', price: 420.0),
    Product(name: 'CHIVAS 21 años', category: 'Whisky', price: 1800.0),
    Product(name: 'JACK DANIELS N7', category: 'Whisky', price: 220.0),
    Product(name: 'JACK DANIELS Apple', category: 'Whisky', price: 220.0),
    Product(name: 'JACK DANIELS Honey', category: 'Whisky', price: 220.0),
    Product(name: 'FLOR DE CAÑA 4 años', category: 'Ron', price: 140.0),
    Product(name: 'FLOR DE CAÑA 5 años', category: 'Ron', price: 170.0),
    Product(name: 'FLOR DE CAÑA 7 años', category: 'Ron', price: 210.0),
    Product(name: 'FLOR DE CAÑA 12 años', category: 'Ron', price: 240.0),
    Product(name: 'CARTAVIO Solera', category: 'Ron', price: 220.0),
    Product(name: 'Mandatario', category: 'Ron', price: 260.0),
    Product(name: 'ZACAPA 23 años', category: 'Ron', price: 450.0),
    Product(name: 'ZACAPA XO', category: 'Ron', price: 1000.0),
    Product(name: 'JOSE CUERVO Reposado', category: 'Tequila', price: 200.0),
    Product(name: 'JIMADOR Reposado', category: 'Tequila', price: 220.0),
    Product(name: '1800 Reposado', category: 'Tequila', price: 240.0),
    Product(name: '1800 Cristalino', category: 'Tequila', price: 500.0),
    Product(name: 'DON JULIO Reposado', category: 'Tequila', price: 500.0),
    Product(name: 'DON JULIO Blanco', category: 'Tequila', price: 600.0),
    Product(name: 'DON JULIO 70 años', category: 'Tequila', price: 700.0),
    Product(name: 'BEEFEATER Pink', category: 'Gin', price: 220.0),
    Product(name: 'TANQUERAY Sevilla', category: 'Gin', price: 260.0),
    Product(name: 'TANQUERAY Dark Berry', category: 'Gin', price: 280.0),
    Product(name: 'BULLDOG', category: 'Gin', price: 260.0),
    Product(name: 'HENDRICK', category: 'Gin', price: 300.0),
    Product(name: 'HENDRICK Neptunia', category: 'Gin', price: 350.0),
    Product(name: 'CUATRO GALLOS Quebranta', category: 'Pisco', price: 150.0),
    Product(name: 'PORTON', category: 'Pisco', price: 200.0),
    Product(name: 'JAGERMEISTER', category: 'Otros', price: 200.0),
    Product(name: 'BAYLEIS', category: 'Espumante', price: 180.0),
    Product(name: 'RICADONNA Ruby', category: 'Espumante', price: 200.0),
    Product(name: 'MOET CHANDON Garden', category: 'Espumante', price: 400.0),
    Product(name: 'MOET CHANDON Imperial', category: 'Espumante', price: 800.0),
    Product(name: 'Agua', category: 'Complementos', price: 5.0),
    Product(name: 'Gaseosa', category: 'Complementos', price: 5.0),
    Product(name: 'Ginger', category: 'Complementos', price: 15.0),
    Product(name: 'Agua Tonica', category: 'Complementos', price: 15.0),
    Product(name: 'CIGARRO Lucky Strike', category: 'Complementos', price: 5.0),
    Product(name: 'Corona', category: 'Cervezas', price: 15.0),
    Product(name: 'Estela', category: 'Cervezas', price: 15.0),
    Product(name: 'Heineken', category: 'Cervezas', price: 15.0),
    Product(name: 'Cóctel Margarita', category: 'Cócteles', price: 25.0),
  ];

  final Map<Product, int> _cart = {};
  String _selectedCategory = 'Todos';

  List<String> get _categories => ['Todos', ..._products.map((p) => p.category).toSet()];

  double get _total => _cart.entries
      .map((e) => e.key.price * e.value)
      .fold(0.0, (a, b) => a + b);

  void _addToCart(Product product) {
    setState(() {
      _cart[product] = (_cart[product] ?? 0) + 1;
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      if (_cart.containsKey(product)) {
        if (_cart[product]! > 1) {
          _cart[product] = _cart[product]! - 1;
        } else {
          _cart.remove(product);
        }
      }
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedProducts = _selectedCategory == 'Todos'
        ? _products
        : _products.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Venta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearCart,
            tooltip: 'Vaciar carrito',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories.map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat),
              )).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: displayedProducts.map((product) {
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text('S/. ${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _addToCart(product),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const Divider(),
            const Text('Carrito de Compras', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _cart.isEmpty
                ? const Text('Carrito vacío')
                : Column(
              children: _cart.entries.map((entry) {
                final product = entry.key;
                final quantity = entry.value;
                return ListTile(
                  title: Text('${product.name} x$quantity'),
                  subtitle: Text('S/. ${(product.price * quantity).toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => _removeFromCart(product),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 80), // Espacio para botón flotante
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: S/. ${_total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: _cart.isEmpty
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        totalAmount: _total,
                        waiterName: 'Mozo 1',
                      ),
                    ),
                  ).then((_) => _clearCart());
                },
                icon: const Icon(Icons.check),
                label: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}