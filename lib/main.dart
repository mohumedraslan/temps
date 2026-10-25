
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_product_catalog/product_widgets.dart';

void main() {
  runApp(const ProductCatalogApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final username = state.uri.queryParameters['user'] ?? 'Guest';
        return ProductsPage(username: username);
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) => DetailsPage(
        name: state.pathParameters['name'] ?? '',
        price: state.pathParameters['price'] ?? '',
      ),
    ),
  ],
);

class ProductCatalogApp extends StatelessWidget {
  const ProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('LoginPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('LoginPage: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('LoginPage: build');
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: FilledButton(
          onPressed: () {
            context.goNamed('products', queryParameters: {'user': 'Guest'});
          },
          child: const Text('Login'),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    debugPrint('LoginPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('LoginPage: dispose');
    super.dispose();
  }
}

class ProductsPage extends StatefulWidget {
  final String username;

  const ProductsPage({super.key, required this.username});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  static const List<Map<String, dynamic>> products = [
    {'name': 'Laptop', 'price': 1200},
    {'name': 'Phone', 'price': 800},
    {'name': 'Keyboard', 'price': 95},
    {'name': 'Headphones', 'price': 150},
  ];

  int favorites = 0;
  double screenWidth = 0;
  String cartMessage = '';

  @override
  void initState() {
    super.initState();
    debugPrint('ProductsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    screenWidth = size.width;
    debugPrint(
      'ProductsPage: didChangeDependencies -> width: ${size.width}, '
      'height: ${size.height}',
    );
  }

  Future<void> openDetails(int index) async {
    final product = products[index];
    final name = product['name'] as String;
    final price = product['price'].toString();
    final result = await context.pushNamed<Object?>(
      'details',
      pathParameters: {'name': name, 'price': price},
    );
    if (!mounted || result == null) return;
    setState(() {
      cartMessage = result as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ProductsPage: build');
    final productList = screenWidth < 600
        ? ProductsListView(
            products: products,
            onFavoritePressed: () {
              setState(() => favorites++);
            },
            onProductTap: openDetails,
          )
        : ProductsGridView(
            products: products,
            onFavoritePressed: () {
              setState(() => favorites++);
            },
            onProductTap: openDetails,
          );

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${widget.username}'),
            Text('Favorites: $favorites'),
            Text('Screen width: ${screenWidth.toStringAsFixed(0)}'),
            if (cartMessage.isNotEmpty) Text(cartMessage),
            const SizedBox(height: 12),
            Expanded(child: productList),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    debugPrint('ProductsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('ProductsPage: dispose');
    super.dispose();
  }
}

class DetailsPage extends StatefulWidget {
  final String name;
  final String price;

  const DetailsPage({super.key, required this.name, required this.price});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('DetailsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('DetailsPage: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DetailsPage: build');
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.name, style: Theme.of(context).textTheme.headlineMedium),
            Text('Price: \$${widget.price}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                context.pop('${widget.name} added to cart');
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    debugPrint('DetailsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('DetailsPage: dispose');
    super.dispose();
  }
}
