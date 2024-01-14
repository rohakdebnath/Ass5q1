import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Cart',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: const ProductListPage(),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  bool isInCart;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.isInCart = false,
  });
}

final List<Product> products = [
  Product(
    id: 'p1',
    name: 'Stamp Coffee MUG',
    image:
        'https://fastly.picsum.photos/id/30/1280/901.jpg?hmac=A_hpFyEavMBB7Dsmmp53kPXKmatwM05MUDatlWSgATE',
    price: 11,
  ),
  Product(
    id: 'p2',
    name: 'Howrah Bridge',
    image:
        'https://fastly.picsum.photos/id/503/5000/3333.jpg?hmac=VzPAu7ms8bk23An5YHB4gd5-A33jzKa4AOC1XANpTks',
    price: 999999,
  ),
  Product(
    id: 'p3',
    name: 'Used Auto-rickshaw',
    image:
        'https://fastly.picsum.photos/id/45/4592/2576.jpg?hmac=Vc7_kMYufvy96FxocZ1Zx6DR1PNsNQXF4XUw1mZ2dlc',
    price: 300,
  ),
  Product(
    id: 'p4',
    name: 'Flower Seed (varities available)',
    image:
        'https://fastly.picsum.photos/id/152/3888/2592.jpg?hmac=M1xv1MzO9xjf5-tz1hGR9bQpNt973ANkqfEVDW0-WYU',
    price: 3,
  ),
  Product(
    id: 'p5',
    name: 'Used SkateBoard (9 years old used with care)',
    image:
        'https://fastly.picsum.photos/id/157/5000/3914.jpg?hmac=A23PziOOpi_DIdiPRI30m9_1A8keOtMF3a6Vb-D7dRA',
    price: 25,
  ),
  Product(
    id: 'p6',
    name: 'Cow',
    image:
        'https://fastly.picsum.photos/id/200/1920/1280.jpg?hmac=-eKjMC8-UrbLMpy1A4OWrK0feVPB3Ka5KNOGibQzpRU',
    price: 15,
  ),
  Product(
    id: 'p7',
    name: 'NiQon Piksel 9700',
    image:
        'https://fastly.picsum.photos/id/454/4403/2476.jpg?hmac=pubXcBaPumNk0jElL63xrQYiSwQWA_DtS8uNNV8PmIE',
    price: 150,
  ),
  Product(
    id: 'p8',
    name: 'Birb',
    image:
        'https://fastly.picsum.photos/id/275/4288/2848.jpg?hmac=DHPZUN0qLc6KRiIP21_mfYCi-BxH9JKNYPPJRhG8t40',
    price: 14,
  ),
  Product(
    id: 'p9',
    name: 'Amazon Kindle',
    image:
        'https://fastly.picsum.photos/id/367/4928/3264.jpg?hmac=H-2OwMlcYm0a--Jd2qaZkXgFZFRxYyGrkrYjupP8Sro',
    price: 80,
  ),
  Product(
    id: 'p10',
    name: 'Raspberries (1kg)',
    image:
        'https://fastly.picsum.photos/id/429/4128/2322.jpg?hmac=_mAS4ToWrJBx29qI2YNbOQ9IyOevQr01DEuCbArqthc',
    price: 30,
  ),
];

class Cart extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  void addProduct(Product product) {
    if (!_items.contains(product)) {
      product.isInCart = true;
      _items.add(product);
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    if (_items.contains(product)) {
      product.isInCart = false;
      _items.remove(product);
      notifyListeners();
    }
  }

  void clearCart() {
    for (var product in products) {
      product.isInCart = false;
    }
    _items.clear();
    notifyListeners();
  }

  double totalAmt() {
    double tot = 0;
    for (var product in products) {
      tot = tot + product.price;
    }
    return tot;
  }
}

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Of Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(30.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(product.image),
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                trailing: IconButton(
                  icon: product.isInCart
                      ? const Icon(Icons.remove_circle)
                      : const Icon(Icons.shopping_basket),
                  onPressed: () {
                    if (product.isInCart) {
                      cart.removeProduct(product);
                    } else {
                      cart.addProduct(product);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final product = cart.items[index];
                    return ListTile(
                      leading: Image.network(product.image),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          cart.removeProduct(product);
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 200, 218, 111),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CHECK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'OUT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
          ),
          onPressed: () {
              Provider.of<Cart>(context, listen: false).clearCart();
          },
          ),
        ],
      ),
    );
  }
}