import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_library_managent/features/profile/data/model/add_product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../data/repository/profileRepositroy.dart';

class AddProductPage extends ConsumerStatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  // Form fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _offerPriceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  File? _selectedImage; // Change from List<File> to File?

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  // Function to open image picker
  Future<void> _pickImage() async {
    // Change function name to _pickImage
    XFile? selectedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (selectedImage != null) {
      setState(() {
        _selectedImage =
            File(selectedImage.path); // Change to File instead of List<File>
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Name Input
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Price Input
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Offer Price Input
            TextFormField(
              controller: _offerPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Offer Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Description Input
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items:
                  ['Acoustic guitars', 'Classical guitar', 'Electric guitars']
                      .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Select Image Button
            ElevatedButton(
              onPressed: _pickImage, // Changed to _pickImage
              child: Text('Select Image'), // Changed text to "Select Image"
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Display Selected Image
            _selectedImage != null // Check if an image is selected
                ? Container(
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  )
                : Container(),
            SizedBox(height: 16.0),

            // Add Product Button
            ElevatedButton(
              onPressed: () async {
                final add = await ref
                    .read(profileRemoteRepositoryProvider)
                    .addProduct(AddProduct(
                      name: _nameController.text,
                      price: double.parse(_priceController.text),
                      offerPrice: double.parse(_offerPriceController.text),
                      description: _descriptionController.text,
                      image: _selectedImage, // Changed to _selectedImage
                      category: _selectedCategory.toString(),
                      stock: 1,
                    ));

                add.fold(
                  (error) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.error.toString()),
                      ),
                    );
                  },
                  (success) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add product Successfully'),
                      ),
                    );
                    // Navigate back to Profile page
                    Navigator.pop(context);
                  },
                );
              },
              child: Text('Add Product'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
