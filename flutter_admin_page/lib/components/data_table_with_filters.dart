// components/data_table_with_filters.dart
import 'package:flutter/material.dart';

class FilterItem {
  final String label;
  final List<String> options;
  final Function(String?) onChanged;

  FilterItem({
    required this.label,
    required this.options,
    required this.onChanged,
  });
}

class DataTableWithFilters extends StatelessWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final List<FilterItem> filters;
  final String searchHint;
  final Function(String) onSearch;
  final Function() onAdd;

  const DataTableWithFilters({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
    required this.filters,
    required this.searchHint,
    required this.onSearch,
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
                  onChanged: onSearch,
                ),
                const SizedBox(height: 16),
                
                // Filters
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: filters.map((filter) {
                    return SizedBox(
                      width: 200,
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
                        value: filter.options.first,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Data Table
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: columns,
                  rows: rows,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) => Colors.blueGrey[50],
                  ),
                  dividerThickness: 1,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 48,
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