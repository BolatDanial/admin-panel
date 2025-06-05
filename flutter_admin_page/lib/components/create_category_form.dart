import 'package:flutter/material.dart';
import 'package:flutter_admin_page/models/category.dart';

class AddCategoryForm extends StatefulWidget {
  final void Function(String name, CategoryGet category, String keywords,
      String photo_path, String badKeywords) onSubmit;
  final List<CategoryGet> availableCategories;

  const AddCategoryForm({
    super.key, 
    required this.onSubmit,
    required this.availableCategories,
  });

  @override
  _AddCategoryFormState createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _keywordsController = TextEditingController();
  final _photoController = TextEditingController();
  final _badKeywordsController = TextEditingController();

  
  CategoryGet? _selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _keywordsController.dispose();
    _photoController.dispose();
    _badKeywordsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please mark category as NewParent or select parent category')),
        );
        return;
      }

      final name = _nameController.text.trim();
      final keywords = _keywordsController.text.trim();
      final photo = _photoController.text.trim();
      final badKeywords = _badKeywordsController.text.trim();
      
      widget.onSubmit(
        name, 
        _selectedCategory!, 
        keywords, 
        photo, 
        badKeywords
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
                Text("Add Category", style: Theme.of(context).textTheme.titleLarge),
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
                DropdownButtonFormField<CategoryGet>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "Parent Category",
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
                  validator: (value) => value == null ? 'Please select a parent category' : null,
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _keywordsController,
                  decoration: const InputDecoration(
                    labelText: "Key words (separate by comma)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter key words (separate by comma)'
                      : null,
                ),
                
                const SizedBox(height: 16),
                TextFormField(
                  controller: _photoController,
                  decoration: const InputDecoration(
                    labelText: "Photo Path",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter photo path'
                      : null,
                ),
              
                const SizedBox(height: 16),
                TextFormField(
                  controller: _badKeywordsController,
                  decoration: const InputDecoration(
                    labelText: "Bad Keywords (separate by comma)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter bad keywords (separate by comma)'
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