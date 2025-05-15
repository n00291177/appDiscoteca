import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
  });
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _filterQuery = '';
  String _selectedCategory = 'Todos';

  // Categorías de ejemplo
  final List<String> _categories = [
    'Todos',
    'Whisky',
    'Ron',
    'Tequila',
    'Gin',
    'Pisco',
    'Espumantes',
    'Otros',
    'Cervezas',
    'Complementos'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Simular la carga de productos
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Método para cargar productos (simulación)
  Future<void> _loadProducts() async {
    // Simulando una carga desde la base de datos
    await Future.delayed(const Duration(seconds: 1));

    // Productos de ejemplo
    final sampleProducts = [
      Product(
        id: '1',
        name: 'JOHNNIE WALKER Red Label',
        price: 140,
        category: 'Whisky',
        stock: 15,
      ),
      Product(
        id: '2',
        name: 'JOHNNIE WALKER Black Label',
        price: 220,
        category: 'Whisky',
        stock: 8,
      ),Product(
        id: '3',
        name: 'JOHNNIE WALKER Double Black',
        price: 280,
        category: 'Whisky',
        stock: 8,
      ),Product(
        id: '4',
        name: 'JOHNNIE WALKER Gold Label',
        price: 500,
        category: 'Whisky',
        stock: 8,
      ),Product(
        id: '5',
        name: 'JOHNNIE WALKER Green Label',
        price: 700,
        category: 'Whisky',
        stock: 8,
      ),Product(
        id: '6',
        name: 'JOHNNIE WALKER Blue Label',
        price: 2000,
        category: 'Whisky',
        stock: 8,
      ),Product(
        id: '7',
        name: 'JOHNNIE WALKER King George',
        price: 5000,
        category: 'Whisky',
        stock: 8,
      ),


      Product(
        id: '8',
        name: 'CHIVAS 12 años',
        price: 220,
        category: 'Whisky',
        stock: 8,
      ),
      Product(
        id: '9',
        name: 'CHIVAS 15 años',
        price: 320,
        category: 'Whisky',
        stock: 8,
      ),Product(
        id: '10',
        name: 'CHIVAS 18 años',
        price: 450,
        category: 'Whisky',
        stock: 8,
      ),Product(
        id: '11',
        name: 'CHIVAS 21 años',
        price: 1800,
        category: 'Whisky',
        stock: 8,
      ),



      Product(
        id: '12',
        name: 'JACK DANIELS N7',
        price: 220,
        category: 'Whisky',
        stock: 25,
      ),
      Product(
        id: '13',
        name: 'JACK DANIELS Apple',
        price: 220,
        category: 'Whisky',
        stock: 25,
      ),
      Product(
        id: '14',
        name: 'JACK DANIELS Honey',
        price: 220,
        category: 'Whisky',
        stock: 25,
      ),



      Product(
        id: '15',
        name: 'ZACAPA 23',
        price: 450,
        category: 'Ron',
        stock: 12,
      ),
      Product(
        id: '16',
        name: 'ZACAPA XO',
        price: 1000,
        category: 'Whisky',
        stock: 12,
      ),




      Product(
        id: '17',
        name: 'BEEFEATER Pink',
        price: 1000,
        category: 'Gin',
        stock: 12,
      ),

    ];

    setState(() {
      _products.addAll(sampleProducts);
      _filteredProducts = List.from(_products);
      _isLoading = false;
    });
  }

  // Filtrar productos basados en texto de búsqueda y categoría
  void _filterProducts() {
    setState(() {
      _filterQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesQuery = product.name.toLowerCase().contains(_filterQuery);
        final matchesCategory = _selectedCategory == 'Todos' || product.category == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  // Cambiar la categoría seleccionada
  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  // Método para añadir stock
  void _addStock(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Agregar Stock - ${_filteredProducts[index].name}'),
        content: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Cantidad a agregar',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              final quantity = int.parse(value);
              setState(() {
                _filteredProducts[index].stock += quantity;
                // Actualizar el producto original
                final originalIndex = _products.indexWhere((p) => p.id == _filteredProducts[index].id);
                if (originalIndex != -1) {
                  _products[originalIndex].stock += quantity;
                }
              });
              Navigator.of(ctx).pop();
            }
          },
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Confirmar'),
            onPressed: () {
              // La acción se maneja en onSubmitted
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Método para editar un producto
  void _editProduct(int index) {
    final product = _filteredProducts[index];
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(text: product.price.toString());
    final stockController = TextEditingController(text: product.stock.toString());
    String selectedCategory = product.category;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio (S/)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Stock disponible',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .where((cat) => cat != 'Todos')
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Guardar'),
            onPressed: () {
              if (nameController.text.isEmpty ||
                  priceController.text.isEmpty ||
                  stockController.text.isEmpty) {
                return;
              }

              final newProduct = Product(
                id: product.id,
                name: nameController.text,
                price: double.parse(priceController.text),
                category: selectedCategory,
                stock: int.parse(stockController.text),
              );

              setState(() {
                // Actualizar en la lista filtrada
                _filteredProducts[index] = newProduct;

                // Actualizar en la lista principal
                final originalIndex = _products.indexWhere((p) => p.id == product.id);
                if (originalIndex != -1) {
                  _products[originalIndex] = newProduct;
                }
              });

              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Método para eliminar un producto
  void _deleteProduct(int index) {
    final product = _filteredProducts[index];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: Text('¿Estás seguro de eliminar "${product.name}"?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
            onPressed: () {
              setState(() {
                // Eliminar de la lista filtrada
                _filteredProducts.removeAt(index);

                // Eliminar de la lista principal
                _products.removeWhere((p) => p.id == product.id);
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Método para agregar un nuevo producto
  void _addNewProduct() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    String selectedCategory = _categories[1]; // Primera categoría que no sea 'Todos'

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio (S/)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Stock inicial',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .where((cat) => cat != 'Todos')
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Guardar'),
            onPressed: () {
              if (nameController.text.isEmpty ||
                  priceController.text.isEmpty ||
                  stockController.text.isEmpty) {
                return;
              }

              final newProduct = Product(
                id: DateTime.now().millisecondsSinceEpoch.toString(), // ID temporal
                name: nameController.text,
                price: double.parse(priceController.text),
                category: selectedCategory,
                stock: int.parse(stockController.text),
              );

              setState(() {
                _products.add(newProduct);
                _applyFilters();
              });

              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Productos'),
        centerTitle: true,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view), text: 'Cuadrícula'),
            Tab(icon: Icon(Icons.list), text: 'Lista'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Barra de búsqueda y filtros
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Barra de búsqueda
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Buscar productos',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterProducts();
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filtros de categoría
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (ctx, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) => _selectCategory(category),
                          backgroundColor: Colors.grey[200],
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Vista de cuadrícula
                _filteredProducts.isEmpty
                    ? const Center(child: Text('No se encontraron productos'))
                    : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (ctx, index) {
                    final product = _filteredProducts[index];
                    final isOutOfStock = product.stock <= 0;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: isOutOfStock
                            ? const BorderSide(color: Colors.red, width: 2)
                            : BorderSide.none,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen del producto
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.restaurant,
                                  size: 60,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),

                          // Información del producto
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'S/ ${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.inventory_2,
                                      size: 16,
                                      color: isOutOfStock
                                          ? Colors.red
                                          : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Stock: ${product.stock}',
                                      style: TextStyle(
                                        fontWeight: isOutOfStock
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isOutOfStock
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.category,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Botones de acción
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: Colors.green,
                                onPressed: () => _addStock(index),
                                tooltip: 'Añadir stock',
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () => _editProduct(index),
                                tooltip: 'Editar',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red,
                                onPressed: () => _deleteProduct(index),
                                tooltip: 'Eliminar',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Vista de lista
                _filteredProducts.isEmpty
                    ? const Center(child: Text('No se encontraron productos'))
                    : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (ctx, index) {
                    final product = _filteredProducts[index];
                    final isOutOfStock = product.stock <= 0;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: isOutOfStock
                            ? const BorderSide(color: Colors.red, width: 1.5)
                            : BorderSide.none,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: isOutOfStock
                              ? Colors.red[100]
                              : Colors.blue[100],
                          child: Icon(
                            Icons.restaurant,
                            color: isOutOfStock
                                ? Colors.red
                                : Colors.blue,
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Categoría: ${product.category}'),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  'S/ ${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Stock: ${product.stock}',
                                  style: TextStyle(
                                    fontWeight: isOutOfStock
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isOutOfStock
                                        ? Colors.red
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              color: Colors.green,
                              onPressed: () => _addStock(index),
                              tooltip: 'Añadir stock',
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () => _editProduct(index),
                              tooltip: 'Editar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                              onPressed: () => _deleteProduct(index),
                              tooltip: 'Eliminar',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: _addNewProduct,
          icon: const Icon(Icons.add),
          label: const Text('Nuevo Producto'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}