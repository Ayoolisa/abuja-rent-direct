import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/listing.dart';

class PostListingScreen extends StatefulWidget {
  const PostListingScreen({super.key});

  @override
  State<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends State<PostListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();

  int bedrooms = 2;
  int bathrooms = 2;

  Future<void> _postListing() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      final newListing = Listing(
        id: '',
        title: _titleController.text.trim(),
        location: _locationController.text.trim(),
        pricePerAnnum: double.parse(_priceController.text.trim()),
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        imageUrls: ['https://picsum.photos/id/1015/800/600'], // temporary placeholder image
        description: _descriptionController.text.trim(),
        landlordPhone: _phoneController.text.trim(),
        availableFrom: DateTime.now().add(const Duration(days: 7)),
        amenities: ['Security', 'Generator', 'Tiled floors', 'Kitchen cabinets'],
      );

      await FirebaseFirestore.instance.collection('listings').add(newListing.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing posted successfully! (Test mode - no image)')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post New Listing (Test Mode)')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Test Mode: No image upload for now', style: TextStyle(color: Colors.orange)),

              const SizedBox(height: 24),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yearly Rent (₦) *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number (234...) *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Bedrooms: '),
                  DropdownButton<int>(
                    value: bedrooms,
                    items: List.generate(6, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
                    onChanged: (v) => setState(() => bedrooms = v!),
                  ),
                  const SizedBox(width: 40),
                  const Text('Bathrooms: '),
                  DropdownButton<int>(
                    value: bathrooms,
                    items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
                    onChanged: (v) => setState(() => bathrooms = v!),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _postListing,
                  child: const Text('Post Listing (Test Mode)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}