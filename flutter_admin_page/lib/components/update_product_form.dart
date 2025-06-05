import 'package:flutter/material.dart';
import 'package:flutter_admin_page/models/brand.dart';
import 'package:flutter_admin_page/models/category.dart';
import 'package:flutter_admin_page/models/product.dart';

class UpdateProductForm extends StatefulWidget {
  final void Function(String name, String article, String barcode,
      CategoryGet category, String description, BrandGet brand, String image) onSubmit;
  final List<BrandGet> availableBrands;
  final List<CategoryGet> availableCategories;
  final ProductGet? oldProduct;

  const UpdateProductForm({
    super.key, 
    required this.onSubmit,
    required this.availableBrands,
    required this.availableCategories,
    required this.oldProduct,
  });

  @override
  _UpdateProductFormState createState() => _UpdateProductFormState();
}

class _UpdateProductFormState extends State<UpdateProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _articleController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;

  BrandGet? _selectedBrand;
  CategoryGet? _selectedCategory;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with initial values if provided
    _nameController = TextEditingController(text: widget.oldProduct?.name ?? '');
    _articleController = TextEditingController(text: widget.oldProduct?.article ?? '');
    _barcodeController = TextEditingController(text: widget.oldProduct?.barcode ?? '');
    _descriptionController = TextEditingController(text: widget.oldProduct?.description ?? '');
    _imageController = TextEditingController(text: widget.oldProduct?.path ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _articleController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedBrand == null || _selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both brand and category')),
        );
        return;
      }

      final name = _nameController.text.trim();
      final article = _articleController.text.trim();
      final barcode = _barcodeController.text.trim();
      final description = _descriptionController.text.trim();
      final image = _imageController.text.trim();
      
      widget.onSubmit(
        name, 
        article, 
        barcode, 
        _selectedCategory!, 
        description, 
        _selectedBrand!, 
        image
      );
      Navigator.pop(context); // close the modal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text("Update Product", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter name';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _articleController,
                  decoration: const InputDecoration(
                    labelText: "Article",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter article'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(
                    labelText: "Barcode",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter barcode'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CategoryGet>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  items: widget.availableCategories.map((CategoryGet category) {
                    return DropdownMenuItem<CategoryGet>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (CategoryGet? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter description'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<BrandGet>(
                  value: _selectedBrand,
                  decoration: const InputDecoration(
                    labelText: "Brand",
                    border: OutlineInputBorder(),
                  ),
                  items: widget.availableBrands.map((BrandGet brand) {
                    return DropdownMenuItem<BrandGet>(
                      value: brand,
                      child: Text(brand.name),
                    );
                  }).toList(),
                  onChanged: (BrandGet? newValue) {
                    setState(() {
                      _selectedBrand = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a brand' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(
                    labelText: "Image Path",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter image'
                      : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 50, 72, 132),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submit,
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}