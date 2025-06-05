import 'package:flutter/material.dart';
import 'package:flutter_admin_page/models/brand.dart';
import 'package:flutter_admin_page/models/category.dart';

class AddBrandForm extends StatefulWidget {
  final void Function(int id, String name, String keyWords) onSubmit;

  const AddBrandForm({
    super.key, 
    required this.onSubmit,
  });

  @override
  _AddBrandFormState createState() => _AddBrandFormState();
}

class _AddBrandFormState extends State<AddBrandForm> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _keyWordsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _keyWordsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final id = int.parse(_idController.text);
      final name = _nameController.text.trim();
      final keyWords = _keyWordsController.text.trim();
      
      widget.onSubmit(
        id,
        name, 
        keyWords,
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
                Text("Add Brand", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: "ID",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter id';
                    if (int.tryParse(value) == null) return 'Enter valid number';
                    return null;
                  },
                ),

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
                  controller: _keyWordsController,
                  decoration: const InputDecoration(
                    labelText: "Key Words (separate by comma)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter key words (separate by comma)'
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