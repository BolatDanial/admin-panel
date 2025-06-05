import 'package:flutter/material.dart';
import 'package:flutter_admin_page/components/data_table_with_filters.dart';
import 'package:flutter_admin_page/models/product.dart';
import 'package:flutter_admin_page/models/category.dart';
import 'package:flutter_admin_page/models/brand.dart';
import 'package:flutter_admin_page/service/products.dart';
import 'package:flutter_admin_page/service/brands.dart';
import 'package:flutter_admin_page/service/categories.dart';
import 'package:flutter_admin_page/components/create_category_form.dart';
import 'package:flutter_admin_page/components/create_brand_form.dart';
import 'package:flutter_admin_page/components/create_product_form.dart';
import 'package:flutter_admin_page/components/update_product_form.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String selectedEmptyFields = 'No';
  String selectedCategory = 'All';
  String currentSearch = '';

  int _limit = 20;
  int _offset = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ProductGet> _products = [];
  List<CategoryGet> _categories = [];
  List<CategoryGet> _parentCategories = [];
  List<BrandGet> _brands = [];


  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _fetchMoreProducts(); 

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && _hasMore) {
        _fetchMoreProducts();
      }
    });
  }


  void applyFilters({String? emptyField, String? category, String? search}) {
    setState(() {
      if (emptyField != null) selectedEmptyFields = emptyField;
      if (category != null) selectedCategory = category;
      if (search != null) currentSearch = search;
    });
    _fetchMoreProducts(reset: true);
  }

  void _openCreateCategoryForm(List<CategoryGet> categories) {
    final newCategories = [CategoryGet(id: '0', name: "New Parent", parent: "0"), ...categories];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddCategoryForm(
        availableCategories: newCategories,
        onSubmit: (name, category, keywords, photo_path, badKeywords) {
          createCategory(CategoryCreate(name: name, parent: category.id, keywords: keywords, photo: photo_path, badKeywords: badKeywords,));
        },
      ),
    );
  }

  void _openCreateBrandForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddBrandForm(
        onSubmit: (id, name, keywords) {
          createBrand(BrandCreate(id: id, name: name, keyWords: keywords.split(',').map((item) => item.trim()).toList()));
        },
      ),
    );
  }

  void _openCreateProductForm(List<BrandGet> brands, List<CategoryGet> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddProductForm(
        availableBrands: brands,
        availableCategories: categories,
        onSubmit: (name, article, barcode, category, description, brand, image) {
          createProduct(ProductCreate(name: name, article: article, barcode: barcode, category: category.id, description: description, brand: brand.id, path: image));
        },
      ),
    );
  }

  void _openUpdateProductForm(List<BrandGet> brands, List<CategoryGet> categories, ProductGet product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => UpdateProductForm(
        availableBrands: brands,
        availableCategories: categories,
        oldProduct: product,
        onSubmit: (name, article, barcode, category, description, brand, image) {
          updateProduct(ProductCreate(name: name, article: article, barcode: barcode, category: category.id, description: description, brand: brand.id, path: image), product.id);
        },
      ),
    );
  }

  Future<void> _fetchInitialData() async {
    final brands = await fetchBrands();
    final categories = await fetchCategories(isParents: false);
    final parentCategories = await fetchCategories(isParents: true);
    setState(() {
      _brands = brands;
      _categories = categories;
      _parentCategories = parentCategories;
    });
  }

  Future<void> _fetchMoreProducts({bool reset = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    if (reset) {
      _offset = 0;
      _hasMore = true;
      _products.clear();
    }

    final newProducts = await fetchProducts(
      emptyField: selectedEmptyFields,
      category: selectedCategory,
      search: currentSearch,
      limit: _limit,
      offset: _offset,
    );

    setState(() {
      _products.addAll(newProducts);
      _offset += _limit;
      _isLoading = false;
      if (newProducts.length < _limit) _hasMore = false;
    });
  }

  Future<void> createCategory(CategoryCreate category) async {
    await postCategory(category);
    _fetchInitialData();
  }

  Future<void> createBrand(BrandCreate brand) async {
    await postBrand(brand);
    _fetchInitialData();
  }

  Future<void> createProduct(ProductCreate product) async {
    await postProduct(product);
    _fetchMoreProducts(reset: true);
  }

  Future<void> updateProduct(ProductCreate product, String id) async {
    await putProduct(product, id);
    _fetchMoreProducts(reset: true);
  }

  Future<void> removeProduct(String id) async {
    await deleteProduct(id);
    _fetchMoreProducts(reset: true);
  }

  @override
  Widget build(BuildContext context) {
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

    if (_products.isEmpty && _isLoading) {
      rows = [
        DataRow(
          cells: List.generate(columns.length, (index) =>
            DataCell(index == 0
              ? const CircularProgressIndicator()
              : const SizedBox.shrink())),
        ),
      ];
    } else if (_products.isEmpty) {
      rows = [
        DataRow(
          cells: List.generate(columns.length, (index) =>
            DataCell(index == 0
              ? const Text('No products found.')
              : const SizedBox.shrink())),
        ),
      ];
    } else {
      rows = _products.map((product) {
        return DataRow(cells: [
          DataCell(SelectableText(product.id)),
          DataCell(Text(product.name)),
          DataCell(Text(product.article)),
          DataCell(SelectableText(product.barcode)),
          DataCell(Text(product.category)),
          DataCell(Text(product.description)),
          DataCell(Text(product.brand)),
          DataCell(Text(product.path)),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.note, size: 18),
                onPressed: () {},
                color: Colors.blueGrey,
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => _openUpdateProductForm(_brands, _categories, product),
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

      if (_isLoading && _hasMore) {
        rows.add(DataRow(cells: List.generate(columns.length, (index) =>
          DataCell(index == 0
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )
            : const SizedBox.shrink()))));
      }
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTableWithFilters(
        title: 'Products',
        columns: columns,
        columnNames: ['ID', 'Name', 'Article', 'Barcode', 'Category', 'Description', 'Brand', 'Image path', 'Actions'],
        truncatedColumns: {'Name', 'Description'},
        filters: [
          FilterItem(
            label: 'Empty fields',
            options: ['No', 'Article', 'Category', 'Description', 'Brand', 'Photo'],
            value: selectedEmptyFields,
            onChanged: (value) => applyFilters(emptyField: value),
          ),
          FilterItem(
            label: 'Category',
            options: ['All', ..._categories.map((c) => c.name)],
            value: selectedCategory,
            onChanged: (value) => applyFilters(category: value),
          ),
        ],
        searchHint: 'Search products...',
        onSearch: (query) => applyFilters(search: query),
        searchController: _searchController,
        scrollController: _scrollController,
        rows: rows,
        onAddProduct: () => _openCreateProductForm(_brands, _categories),
        onAddBrand: () => _openCreateBrandForm(),
        onAddCategory: () => _openCreateCategoryForm(_parentCategories),
      ),
    );
  }
}
