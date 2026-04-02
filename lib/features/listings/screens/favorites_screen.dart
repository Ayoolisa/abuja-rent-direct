import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/listing.dart';
import 'listing_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Set<String> _favoriteIds = {}; // Will be replaced with real persistence later

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Listings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('listings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading saved listings'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // For now, show all listings (we'll improve favorites logic later)
          final allListings = snapshot.data!.docs
              .map((doc) => Listing.fromFirestore(doc))
              .toList();

          if (allListings.isEmpty) {
            return const Center(child: Text('No listings yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allListings.length,
            itemBuilder: (context, index) {
              final listing = allListings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: const Color(0xFF1E1E1E),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing)),
                  ),
                  leading: listing.imageUrls.isNotEmpty
                      ? Image.network(listing.imageUrls[0], width: 70, fit: BoxFit.cover)
                      : const Icon(Icons.home, size: 50),
                  title: Text(listing.title),
                  subtitle: Text(listing.location),
                  trailing: Text(
                    listing.formattedPrice,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}