import 'package:flutter/material.dart';
import 'package:flutter_admin_page/components/data_table_with_filters.dart';
import 'package:flutter_admin_page/models/product.dart';
import 'package:flutter_admin_page/models/category.dart';
import 'package:flutter_admin_page/requests/products.dart';
import 'package:flutter_admin_page/requests/categories.dart';
import 'package:flutter_admin_page/components/create_product_form.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String selectedEmptyFields = 'No';
  String selectedCategory = 'All';
  String currentSearch = '';

  late Future<_ProductPageData> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchPageData();
  }

  void applyFilters({String? emptyField, String? category, String? search}) {
    setState(() {
      if (emptyField != null) selectedEmptyFields = emptyField;
      if (category != null) selectedCategory = category;
      if (search != null) currentSearch = search;
      futureData = fetchPageData();
    });
  }

  void _openCreateProductForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddProductForm(
        onSubmit: (id, name, article, barcode, category, description, brand, image) {
          createProduct(ProductCreate(id: id, name: name, article: article, barcode: barcode, category: category, description: description, brand: brand, path: image));
        },
      ),
    );
  }
  Future<_ProductPageData> fetchPageData() async {
    final categories = await fetchCategories();
    final products = await fetchProducts(
      emptyField: selectedEmptyFields,
      category: selectedCategory,
      search: currentSearch,
    );
    return _ProductPageData(products: products, categories: categories);
  }

  Future<void> createProduct(ProductCreate product) async {
    await postProduct(product);
  }

  Future<void> removeProduct(String id) async {
    await deleteProduct(id);
    setState(() {
      futureData = fetchPageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<_ProductPageData>(
        future: futureData,
        builder: (context, snapshot) {
          const columns = [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Article')),
            DataColumn(label: Text('Barcode')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Brand')),
            DataColumn(label: Text('Image path')),
            DataColumn(label: Text('Actions')),
          ];

          List<DataRow> rows = [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            rows = [
              DataRow(
                cells: List.generate(columns.length, (index) =>
                  DataCell(index == 0
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink())),
              ),
            ];
          } else if (snapshot.hasError) {
            rows = [
              DataRow(
                cells: List.generate(columns.length, (index) =>
                  DataCell(index == 0
                    ? Text('Error: ${snapshot.error}')
                    : const SizedBox.shrink())),
              ),
            ];
          } else {
            final data = snapshot.data!;
            final products = data.products;
            final categories = data.categories;

            if (products.isEmpty) {
              rows = [
                DataRow(
                  cells: List.generate(columns.length, (index) =>
                    DataCell(index == 0
                      ? const Text('No products found.')
                      : const SizedBox.shrink())),
                ),
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
                        onPressed: () => removeProduct(product.id),
                        color: Colors.red[300],
                      ),
                    ],
                  )),
                ]);
              }).toList();
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
                  options: ['All', ...categories.map((c) => c.name)],
                  value: selectedCategory,
                  onChanged: (value) => applyFilters(category: value),
                ),
              ],
              searchHint: 'Search products...',
              onSearch: (query) => applyFilters(search: query),
              onChanged: (query) {},
              rows: rows,
              onAdd: () => _openCreateProductForm(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProductPageData {
  final List<ProductGet> products;
  final List<Category> categories;

  _ProductPageData({required this.products, required this.categories});
}
