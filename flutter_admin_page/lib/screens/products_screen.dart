// screens/products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admin_page/components/data_table_with_filters.dart';
import 'package:flutter_admin_page/models/product.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final List<Product> products = [
      Product(id: '005aa8e7-cd9f-4022-97c5-6a430f452583', name: 'Паста "Карбонара" в сырном соусе 290г (6)', article: "386", barcode: "4607016248509", category: 'Electronics', description: "Паста \“Карбонара\” легко и непринужденно перемещается из итальянского ресторана на вашу кухню. Шеф-повар уже передал свой секретный густой сырный соус. Осталось отварить пасту из твердых сортов пшеницы, обжарить ароматный бекон (или ветчину) до золотистой корочки, добавить готовый соус и подать блюдо, посыпав пармезаном и не забыв традиционный яичный желток сверху. Buon appetito! Набор для приготовления \«Паста \«Карбонара\» в сырном соусе\».", brand: "", isActive: false, isFilled: false, path: "http://appartement.alym.kz/img/"),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DataTableWithFilters(
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
            options: ['All', 'Electronics', 'Furniture', 'Kitchen'],
            onChanged: (value) {},
          ),
          FilterItem(
            label: 'Stock',
            options: ['All', 'Low (<10)', 'Medium (10-30)', 'High (>30)'],
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
        }).toList(),
        onAdd: () {},
      ),
    );
  }
}