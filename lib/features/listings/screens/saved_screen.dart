import 'package:flutter/material.dart';
import '../models/listing.dart';
import 'listing_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final savedListings = Listing.getSampleListings()
        .where((listing) => Listing.favorites.contains(listing.id))
        .toList();

    if (savedListings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('No saved listings yet', style: TextStyle(fontSize: 20)),
            Text('Tap the ❤️ on any listing to save it', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Listings')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: savedListings.length,
        itemBuilder: (context, index) {
          final listing = savedListings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(listing.imageUrls.first, width: 80, height: 80, fit: BoxFit.cover),
              ),
              title: Text(listing.title),
              subtitle: Text('${listing.location}\n${listing.formattedPrice}'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing))),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  setState(() => Listing.favorites.remove(listing.id));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${listing.title} removed')));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}