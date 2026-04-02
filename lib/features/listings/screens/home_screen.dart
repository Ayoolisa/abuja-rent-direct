import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/listing.dart';
import 'listing_detail_screen.dart';
import 'post_listing_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  // Pre-populated realistic listings (so app looks alive immediately)
  final List<Listing> _sampleListings = [
    Listing(
      id: '1',
      title: 'Spacious 2 Bedroom Apartment',
      location: 'Garki II, Abuja',
      pricePerAnnum: 5400000,
      bedrooms: 2,
      bathrooms: 2,
      imageUrls: ['https://picsum.photos/id/1015/800/600'],
      description: 'Beautiful 2 bedroom apartment in a secured estate with constant power and water.',
      landlordPhone: '2348012345678',
      availableFrom: DateTime.now().add(const Duration(days: 5)),
      amenities: ['POP ceiling', 'Fully tiled', 'Kitchen cabinets', 'Balcony', '24/7 Security'],
    ),
    Listing(
      id: '2',
      title: 'Luxury 3 Bedroom Terrace',
      location: 'Maitama, Abuja',
      pricePerAnnum: 14400000,
      bedrooms: 3,
      bathrooms: 3,
      imageUrls: ['https://picsum.photos/id/106/800/600'],
      description: 'Brand new terrace with premium finishes, generator and private garden.',
      landlordPhone: '2348098765432',
      availableFrom: DateTime.now().add(const Duration(days: 10)),
      amenities: ['Generator', 'Borehole', 'Garden', 'CCTV'],
    ),
    Listing(
      id: '3',
      title: 'Self Contained Mini Flat',
      location: 'Kubwa, Abuja',
      pricePerAnnum: 3360000,
      bedrooms: 1,
      bathrooms: 1,
      imageUrls: ['https://picsum.photos/id/133/800/600'],
      description: 'Neat self-contained unit with good road access and security.',
      landlordPhone: '2347087654321',
      availableFrom: DateTime.now().add(const Duration(days: 7)),
      amenities: ['AC', 'Wardrobe', 'Kitchenette'],
    ),
    Listing(
      id: '4',
      title: '4 Bedroom Bungalow',
      location: 'Wuse II, Abuja',
      pricePerAnnum: 11400000,
      bedrooms: 4,
      bathrooms: 4,
      imageUrls: ['https://picsum.photos/id/180/800/600'],
      description: 'Spacious bungalow with boys quarter and large compound.',
      landlordPhone: '2348034567890',
      availableFrom: DateTime.now().add(const Duration(days: 15)),
      amenities: ['Boys quarter', 'Compound', 'Generator', 'Car port'],
    ),
  ];

  void _applyFilters() {
    setState(() {});
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter Listings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: ['All', '1 Bedroom', '2 Bedroom', '3+ Bedroom', 'Under ₦6M/Year']
                  .map((filter) => ChoiceChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        onSelected: (selected) {
                          setState(() => _selectedFilter = filter);
                          Navigator.pop(context);
                          _applyFilters();
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var filteredListings = _sampleListings.where((listing) {
      final query = _searchController.text.toLowerCase();
      final matchesSearch = query.isEmpty ||
          listing.title.toLowerCase().contains(query) ||
          listing.location.toLowerCase().contains(query);

      if (_selectedFilter == 'All') return matchesSearch;
      if (_selectedFilter == '1 Bedroom') return matchesSearch && listing.bedrooms == 1;
      if (_selectedFilter == '2 Bedroom') return matchesSearch && listing.bedrooms == 2;
      if (_selectedFilter == '3+ Bedroom') return matchesSearch && listing.bedrooms >= 3;
      if (_selectedFilter == 'Under ₦6M/Year') return matchesSearch && listing.pricePerAnnum < 6000000;
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Abuja Rent Direct')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _applyFilters(),
                    decoration: InputDecoration(
                      hintText: 'Search by area (Garki, Maitama...)',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.filter_list, size: 28), onPressed: _showFilterBottomSheet),
              ],
            ),
          ),

          Expanded(
            child: filteredListings.isEmpty
                ? const Center(child: Text('No listings found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredListings.length,
                    itemBuilder: (context, index) {
                      final listing = filteredListings[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing)),
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 20),
                          color: const Color(0xFF1E1E1E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(height: 220, viewportFraction: 1.0),
                                items: listing.imageUrls.isNotEmpty
                                    ? [listing.imageUrls.first]
                                        .map((url) => Image.network(url, fit: BoxFit.cover, width: double.infinity))
                                        .toList()
                                    : [const Icon(Icons.home, size: 100, color: Colors.grey)],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(listing.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                    Text(listing.location, style: TextStyle(color: Colors.grey[400])),
                                    const SizedBox(height: 8),
                                    Text(listing.formattedPrice, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  ],
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_home),
        label: const Text('Post Listing'),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostListingScreen())),
      ),
    );
  }
}