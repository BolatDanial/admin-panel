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
  String selectedEmptyFields = 'No';
  String selectedCategory = 'All';
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  void applyFilters({String? emptyField, String? category}) {
    setState(() {
      if (emptyField != null) selectedEmptyFields = emptyField;
      if (category != null) selectedCategory = category;
      futureProducts = fetchProducts(emptyField: selectedEmptyFields, category: selectedCategory);
    });
  }

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        // Define your columns once
        const columns = [
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
        ];

        // Handle different states while maintaining column count
        List<DataRow> rows = [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          rows = [
            DataRow(cells: List.generate(columns.length, (index) => 
              DataCell(index == 0 
                ? const CircularProgressIndicator() 
                : const SizedBox.shrink()
              )
            ))
          ];
        } else if (snapshot.hasError) {
          rows = [
            DataRow(cells: List.generate(columns.length, (index) => 
              DataCell(index == 0 
                ? Text('Error: ${snapshot.error}') 
                : const SizedBox.shrink()
              )
            ))
          ];
        } else {
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            rows = [
              DataRow(cells: List.generate(columns.length, (index) => 
                DataCell(index == 0 
                  ? const Text('No products found.') 
                  : const SizedBox.shrink()
                )
              ))
            ];
          } else {
            rows = products.map((product) {
              return DataRow(cells: [
                DataCell(Text(product.id)),
                DataCell(Text(product.name)),
                DataCell(Text(product.article)),
                DataCell(Text(product.barcode)),
                DataCell(Text(product.category)),
                DataCell(Text(product.description)),
                DataCell(Text(product.brand)),
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
            }).toList();
          }
        }

        return DataTableWithFilters(
          title: 'Products',
          columns: columns,
          filters: [
            FilterItem(
              label: 'Empty fields',
              options: ['No', 'Article', 'Category', 'Description', 'Brand', 'Photo'],
              value: selectedEmptyFields,
              onChanged: (value) => applyFilters(emptyField: value),
            ),
            FilterItem(
              label: 'Category',
              options: ['All', 'Крупы'],
              value: selectedCategory,
              onChanged: (value) => applyFilters(category: value),
            ),
          ],
          searchHint: 'Search products...',
          onSearch: (query) {},
          rows: rows,
          onAdd: () {},
        );
      },
    ),
  );
}
}
