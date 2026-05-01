import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/listing.dart';
import 'listing_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final listings = Listing.getSampleListings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Abuja Rent Direct'),
        backgroundColor: const Color(0xFF0A0A0A),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by area (Garki, Maitama...)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: const Color(0xFF121212),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final listing = listings[index];
                final isFavorite = Listing.favorites.contains(listing.id);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing)),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 200,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                enableInfiniteScroll: false,
                              ),
                              items: listing.imageUrls.map((url) {
                                return Image.network(
                                  url,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(listing.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text(listing.location, style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  Text(listing.formattedPrice, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text('${listing.bedrooms} bed • ${listing.bathrooms} bath'),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Favorite heart
                        Positioned(
                          top: 12,
                          right: 12,
                          child: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isFavorite) {
                                  Listing.favorites.remove(listing.id);
                                } else {
                                  Listing.favorites.add(listing.id);
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isFavorite ? '${listing.title} removed' : '${listing.title} saved!'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}