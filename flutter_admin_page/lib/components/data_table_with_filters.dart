// components/data_table_with_filters.dart
import 'package:flutter/material.dart';
import 'package:flutter_admin_page/models/product.dart';

class FilterItem extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  const FilterItem({
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value ?? options.first,
      onChanged: onChanged,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }
}

List<DataRow> buildRows(AsyncSnapshot<List<ProductGet>> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return [
      DataRow(cells: [
        DataCell(ColoredBox(
          color: Colors.grey[200]!,
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          ),
        )),
      ])
    ];
  } else if (snapshot.hasError) {
    return [
      DataRow(cells: [
        DataCell(ColoredBox(
          color: Colors.grey[200]!,
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Center(child: Text('Error: ${snapshot.error}')),
          ),
        )),
      ])
    ];
  }

  final products = snapshot.data ?? [];
  if (products.isEmpty) {
    return [
      DataRow(cells: [
        DataCell(ColoredBox(
          color: Colors.grey[200]!,
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Center(child: Text('No products found.')),
          ),
        )),
      ])
    ];
  }

  return products.map((product) {
    return DataRow(cells: [
      // ... your data cells ...
    ]);
  }).toList();
}


class DataTableWithFilters extends StatelessWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final List<FilterItem> filters;
  final String searchHint;
  final Function(String) onSearch;
  final Function(String) onChanged;
  final Function() onAdd;

  const DataTableWithFilters({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
    required this.filters,
    required this.searchHint,
    required this.onSearch,
    required this.onChanged,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and add button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add New'),
              onPressed: onAdd,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[700],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Filters and search
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: searchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: onSearch,
                  onChanged: onChanged,
                ),
                const SizedBox(height: 16),
                
                // Filters
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: filters.map((filter) {
                    return SizedBox(
                      width: 250,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: filter.label,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: filter.options.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: filter.onChanged,
                        value: filter.value,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: columns,
                  rows: rows.map((row) {
                    return DataRow(
                      cells: row.cells.map((cell) {
                        return DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 100, // Set your minimum width
                              maxWidth: 600, // Set your maximum width
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: DefaultTextStyle.merge(
                                softWrap: true,
                                child: cell.child ?? const SizedBox(),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) => Colors.blueGrey[50],
                  ),
                  dividerThickness: 1,
                  showBottomBorder: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}