import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/product/product_form.dart';
import '../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedCategoryId = '';
  File? _imageFile;
  String? _currentImageUrl;
  bool _isLoading = false;
  List<Map<String, String>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadProductData();
    _fetchCategories();
  }

  void _loadProductData() {
    _nameController.text = widget.product.name;
    _descriptionController.text = widget.product.description;
    _priceController.text = widget.product.price.toString();
    _quantityController.text = widget.product.quantity.toString();
    _selectedCategoryId = widget.product.categoryId;
    _currentImageUrl = widget.product.imageUrl;
  }

  Future<void> _fetchCategories() async {
    try {
      final categoriesSnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      List<Map<String, String>> fetchedCategories = [];
      for (var doc in categoriesSnapshot.docs) {
        fetchedCategories.add({
          'id': doc.id,
          'name': doc['name'] as String,
        });
      }

      setState(() {
        _categories = fetchedCategories;

        // Vérifier si la catégorie du produit existe dans les catégories récupérées
        if (_selectedCategoryId.isEmpty && _categories.isNotEmpty) {
          _selectedCategoryId = _categories[0]['id']!;
        } else if (!_categories
                .any((category) => category['id'] == _selectedCategoryId) &&
            _categories.isNotEmpty) {
          _selectedCategoryId = _categories[0]['id']!;
        }
      });
    } catch (error) {
      print('Erreur lors de la récupération des catégories: $error');
    }
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return _currentImageUrl;

    try {
      final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('products/$fileName');

      final UploadTask uploadTask = storageRef.putFile(_imageFile!);
      final TaskSnapshot taskSnapshot = await uploadTask;

      return await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      print('Erreur lors de l\'upload de l\'image: $error');
      return _currentImageUrl;
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une catégorie')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = await _uploadImage();

      final updatedProduct = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text.replaceAll(',', '.')),
        'quantity': int.parse(_quantityController.text),
        'categoryId': _selectedCategoryId,
        'imageUrl': imageUrl ?? _currentImageUrl ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update(updatedProduct);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit mis à jour avec succès')),
      );

      // Navigation vers la liste des produits de la catégorie
      context.go('/product-list/$_selectedCategoryId');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $error')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Modifier le produit'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ProductForm(
                formKey: _formKey,
                nameController: _nameController,
                descriptionController: _descriptionController,
                priceController: _priceController,
                quantityController: _quantityController,
                selectedCategory: _selectedCategoryId,
                categories:
                    _categories.map((category) => category['name']!).toList(),
                imageFile: _imageFile,
                currentImageUrl: _currentImageUrl,
                onCategoryChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                onSelectImage: _selectImage,
                onSubmit: _updateProduct,
                submitButtonText: 'Mettre à jour',
                submitButtonColor: Colors.blueAccent,
              ));
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer le produit'),
        content: const Text(
            'Êtes-vous sûr de vouloir supprimer ce produit ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();

              setState(() {
                _isLoading = true;
              });

              try {
                // Supprimer l'image du stockage si elle existe
                if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
                  try {
                    // Extraire le nom du fichier de l'URL
                    final fileName =
                        _currentImageUrl!.split('/').last.split('?').first;
                    final storageRef = FirebaseStorage.instance
                        .ref()
                        .child('products/$fileName');
                    await storageRef.delete();
                  } catch (error) {
                    print('Erreur lors de la suppression de l\'image: $error');
                    // Continuer malgré l'erreur de suppression de l'image
                  }
                }

                // Supprimer le document produit
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.product.id)
                    .delete();

                setState(() {
                  _isLoading = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produit supprimé avec succès')),
                );

                // Navigation vers la liste des produits de la catégorie
                context.go('/product-list/${widget.product.categoryId}');
              } catch (error) {
                setState(() {
                  _isLoading = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Erreur lors de la suppression: $error')),
                );
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
