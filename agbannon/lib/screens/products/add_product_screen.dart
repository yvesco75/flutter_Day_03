import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/product/product_form.dart';
import '../../models/product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedCategory = '';
  File? _imageFile;
  bool _isLoading = false;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categoriesSnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      List<String> fetchedCategories = [];
      for (var doc in categoriesSnapshot.docs) {
        fetchedCategories.add(doc['name']);
      }

      setState(() {
        _categories = fetchedCategories;

        // Gestion du cas où aucune catégorie n'est disponible
        if (_categories.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Aucune catégorie disponible. Veuillez en créer une.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          _selectedCategory =
              _categories[0]; // Sélectionnez la première catégorie par défaut
        }
      });

      print('Catégories chargées: $_categories'); // Debug
    } catch (error) {
      print('Erreur lors de la récupération des catégories: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de chargement des catégories: $error'),
          backgroundColor: Colors.red,
        ),
      );
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
    if (_imageFile == null) return null;

    try {
      final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('products/$fileName');

      final UploadTask uploadTask = storageRef.putFile(_imageFile!);
      final TaskSnapshot taskSnapshot = await uploadTask;

      return await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      print('Erreur lors de l\'upload de l\'image: $error');
      return null;
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez corriger les erreurs dans le formulaire.')),
      );
      return;
    }

    if (_selectedCategory.isEmpty) {
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

      // Extraire les données des contrôleurs
      String name = _nameController.text.trim();
      String description = _descriptionController.text.trim();
      double price = double.parse(_priceController.text.replaceAll(',', '.'));
      int quantity = int.parse(_quantityController.text);

      print('Produit sauvegardé :');
      print('Nom : $name');
      print('Description : $description');
      print('Prix : $price');
      print('Quantité : $quantity');
      print('Catégorie : $_selectedCategory');
      print('Fichier image : ${_imageFile?.path}');

      final newProduct = {
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'category': _selectedCategory,
        'imageUrl': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('products').add(newProduct);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit ajouté avec succès')),
      );

      Navigator.of(context).pop();
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
        title: const Text('Ajouter un produit'),
        backgroundColor: Colors.blueAccent, // Couleur de l'appBar
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blueAccent), // Couleur du loader
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ProductForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  descriptionController: _descriptionController,
                  priceController: _priceController,
                  quantityController: _quantityController,
                  selectedCategory: _selectedCategory,
                  categories: _categories,
                  imageFile: _imageFile,
                  onCategoryChanged: (value) {
                    setState(() {
                      _selectedCategory =
                          value; // Mettre à jour la catégorie sélectionnée
                    });
                  },
                  onSelectImage: _selectImage,
                  onSubmit: _saveProduct,
                  submitButtonText: 'Ajouter',
                  submitButtonColor:
                      Colors.blueAccent, // Couleur du bouton d'ajout
                ),
              ),
            ),
    );
  }
}
