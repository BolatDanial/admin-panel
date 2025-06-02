// screens/products_screen.dart
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_admin_page/components/data_table_with_filters.dart';
import 'package:flutter_admin_page/requests/get_products.dart';
import 'package:flutter_admin_page/models/product.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts(); 
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;

          return DataTableWithFilters(
            title: 'Products',
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Article')),
              DataColumn(label: Text('Barcode')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Brand')),
              DataColumn(label: Text('Is Active?')),
              DataColumn(label: Text('Is filled?')),
              DataColumn(label: Text('Image path')),
              DataColumn(label: Text('Actions')),
            ],
            filters: [
              FilterItem(
                label: 'Category',
                options: ['All'],
                onChanged: (value) {},
              ),
              FilterItem(
                label: 'Stock',
                options: ['All'],
                onChanged: (value) {},
              ),
            ],
            searchHint: 'Search products...',
            onSearch: (query) {},
            rows: products.map((product) {
              return DataRow(cells: [
                DataCell(Text(product.id)),
                DataCell(Text(product.name)),
                DataCell(Text(product.article)),
                DataCell(Text(product.barcode)),
                DataCell(Text(product.category)),
                DataCell(Text(product.description)),
                DataCell(Text(product.brand.toString())),
                DataCell(Text(product.isActive.toString())),
                DataCell(Text(product.isFilled.toString())),
                DataCell(Text(product.path)),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () {},
                      color: Colors.blueGrey,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: () {},
                      color: Colors.red[300],
                    ),
                  ],
                )),
              ]);
            }).toList(),
            onAdd: () {},
          );
        },
      ),
    );
  }
}
