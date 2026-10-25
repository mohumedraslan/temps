
import 'package:flutter/material.dart';

class ProductsListView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function() onFavoritePressed;
  final void Function(int index) onProductTap;

  const ProductsListView({
    super.key,
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductTile(
          name: products[index]['name'] as String,
          price: products[index]['price'] as int,
          onFavoritePressed: onFavoritePressed,
          onTap: () => onProductTap(index),
        );
      },
    );
  }
}

class ProductsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function() onFavoritePressed;
  final void Function(int index) onProductTap;

  const ProductsGridView({
    super.key,
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 4,
      ),
      itemBuilder: (context, index) {
        return ProductTile(
          name: products[index]['name'] as String,
          price: products[index]['price'] as int,
          onFavoritePressed: onFavoritePressed,
          onTap: () => onProductTap(index),
        );
      },
    );
  }
}

class ProductTile extends StatelessWidget {
  final String name;
  final int price;
  final void Function() onFavoritePressed;
  final void Function() onTap;

  const ProductTile({
    super.key,
    required this.name,
    required this.price,
    required this.onFavoritePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(name),
        subtitle: Text('\$$price'),
        trailing: IconButton(
          tooltip: 'Add $name to favorites',
          icon: const Icon(Icons.favorite),
          color: Colors.red,
          onPressed: onFavoritePressed,
        ),
        onTap: onTap,
      ),
    );
  }
}
