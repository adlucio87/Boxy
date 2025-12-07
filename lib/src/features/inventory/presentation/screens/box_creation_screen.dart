import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/enums/enums.dart';
import '../../logic/box_creation_controller.dart';
import '../widgets/box_qr_widget.dart';

class BoxCreationScreen extends StatefulWidget {
  const BoxCreationScreen({super.key});

  @override
  State<BoxCreationScreen> createState() => _BoxCreationScreenState();
}

class _BoxCreationScreenState extends State<BoxCreationScreen> {
  // Logic controller (In a real app, provided via Provider/Riverpod/GetIt)
  late final BoxCreationController _controller;
  final ImagePicker _picker = ImagePicker();

  // Form State
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController(text: "Milano"); // Default for demo
  SaleType _saleType = SaleType.blindBox;
  bool _isPublic = false;

  @override
  void initState() {
    super.initState();
    _controller = BoxCreationController();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {}); // Rebuild UI on state change
  }

  Future<void> _pickImage() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        await _controller.addItemFromImage(photo.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _createBox() async {
    if (_formKey.currentState!.validate()) {
      // In a real app, get ownerId from Auth Service
      const mockOwnerId = "user_123";

      await _controller.createBox(
        ownerId: mockOwnerId,
        name: _nameController.text,
        location: _locationController.text,
        city: _cityController.text,
        isPublic: _isPublic,
        saleType: _saleType,
      );

      if (_controller.createdBox != null && mounted) {
        _showQrDialog();
      } else if (_controller.errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_controller.errorMessage!)),
        );
      }
    }
  }

  void _showQrDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Box Created!'),
        content: BoxQrWidget(box: _controller.createdBox!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Box'),
      ),
      body: _controller.isProcessing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Items List
                  Text('Items (${_controller.items.length})',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (_controller.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No items yet. Take a photo!',
                          textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _controller.items.length,
                      itemBuilder: (context, index) {
                        final item = _controller.items[index];
                        return Card(
                          child: ListTile(
                            leading: Image.file(
                              File(item.imageUrls.first),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            ),
                            title: Text(item.name),
                            subtitle: Text(item.aiTags.take(3).join(', ')),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _controller.removeItem(item.id),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Add Item from Camera'),
                  ),

                  const Divider(height: 32),

                  // Box Details Form
                  Text('Box Details', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Box Name',
                            hintText: 'e.g. Winter Clothes',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter a name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location (Room)',
                            hintText: 'e.g. Basement',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter a location' : null,
                        ),
                         const SizedBox(height: 12),
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter a city' : null,
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          title: const Text('Public Listing'),
                          subtitle: const Text('Allow others to see this box for sale?'),
                          value: _isPublic,
                          onChanged: (val) => setState(() => _isPublic = val),
                        ),
                        if (_isPublic)
                          DropdownButtonFormField<SaleType>(
                            value: _saleType,
                            decoration: const InputDecoration(
                              labelText: 'Sale Type',
                              border: OutlineInputBorder(),
                            ),
                            items: SaleType.values.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _saleType = val!),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _controller.items.isNotEmpty ? _createBox : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('FINISH & CREATE BOX'),
                  ),
                ],
              ),
            ),
    );
  }
}
