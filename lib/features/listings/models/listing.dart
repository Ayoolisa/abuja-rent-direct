import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String title;
  final String location;
  final double pricePerAnnum;
  final int bedrooms;
  final int bathrooms;
  final List<String> imageUrls;
  final String description;
  final String landlordPhone;
  final DateTime availableFrom;
  final List<String> amenities;

  Listing({
    required this.id,
    required this.title,
    required this.location,
    required this.pricePerAnnum,
    required this.bedrooms,
    this.bathrooms = 1,
    required this.imageUrls,
    required this.description,
    required this.landlordPhone,
    required this.availableFrom,
    required this.amenities,
  });

  String get formattedPrice {
    return '₦${pricePerAnnum.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} / year';
  }

  // Shared favorites (works across Home and Saved tabs)
  static final Set<String> favorites = {};

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'pricePerAnnum': pricePerAnnum,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'imageUrls': imageUrls,
      'description': description,
      'landlordPhone': landlordPhone,
      'availableFrom': Timestamp.fromDate(availableFrom),
      'amenities': amenities,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory Listing.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Listing(
      id: doc.id,
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      pricePerAnnum: (data['pricePerAnnum'] ?? 0).toDouble(),
      bedrooms: data['bedrooms'] ?? 1,
      bathrooms: data['bathrooms'] ?? 1,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      description: data['description'] ?? '',
      landlordPhone: data['landlordPhone'] ?? '',
      availableFrom: (data['availableFrom'] as Timestamp?)?.toDate() ?? DateTime.now(),
      amenities: List<String>.from(data['amenities'] ?? []),
    );
  }

  // 9 realistic Abuja listings with better house images
  static List<Listing> getSampleListings() {
    return [
      Listing(
        id: '1',
        title: 'Spacious 2 Bedroom Apartment',
        location: 'Garki II, Abuja',
        pricePerAnnum: 5400000,
        bedrooms: 2,
        bathrooms: 2,
        imageUrls: ['https://picsum.photos/id/1015/800/600', 'https://picsum.photos/id/133/800/600'],
        description: 'Beautiful 2 bedroom apartment in a secure estate.',
        landlordPhone: '2347082762662',
        availableFrom: DateTime.now().add(const Duration(days: 14)),
        amenities: ['24/7 Security', 'Generator', 'Parking'],
      ),
      Listing(
        id: '2',
        title: 'Luxury 3 Bedroom Terrace',
        location: 'Maitama, Abuja',
        pricePerAnnum: 14400000,
        bedrooms: 3,
        bathrooms: 3,
        imageUrls: ['https://picsum.photos/id/106/800/600', 'https://picsum.photos/id/1074/800/600'],
        description: 'Premium 3 bedroom terrace in Maitama.',
        landlordPhone: '234908187277',
        availableFrom: DateTime.now().add(const Duration(days: 7)),
        amenities: ['Swimming Pool', 'Gym', 'Garden'],
      ),
      Listing(
        id: '3',
        title: 'Cozy Self-Contained Apartment',
        location: 'Kubwa, Abuja',
        pricePerAnnum: 3600000,
        bedrooms: 1,
        bathrooms: 1,
        imageUrls: ['https://picsum.photos/id/201/800/600', 'https://picsum.photos/id/133/800/600'],
        description: 'Affordable self-contained unit for singles.',
        landlordPhone: '2347067521016',
        availableFrom: DateTime.now().add(const Duration(days: 21)),
        amenities: ['Security', 'Kitchenette'],
      ),
      Listing(
        id: '4',
        title: '4 Bedroom Detached Duplex',
        location: 'Wuse, Abuja',
        pricePerAnnum: 18500000,
        bedrooms: 4,
        bathrooms: 4,
        imageUrls: ['https://picsum.photos/id/106/800/600', 'https://picsum.photos/id/175/800/600'],
        description: 'Spacious duplex with boys quarter.',
        landlordPhone: '2348034567890',
        availableFrom: DateTime.now().add(const Duration(days: 10)),
        amenities: ['Boys Quarter', 'CCTV', 'Garden'],
      ),
      Listing(
        id: '5',
        title: 'Modern 3 Bedroom Apartment',
        location: 'Guzape, Abuja',
        pricePerAnnum: 9600000,
        bedrooms: 3,
        bathrooms: 3,
        imageUrls: ['https://picsum.photos/id/1015/800/600', 'https://picsum.photos/id/201/800/600'],
        description: 'Brand new 3 bedroom in a gated community.',
        landlordPhone: '2348098765432',
        availableFrom: DateTime.now().add(const Duration(days: 15)),
        amenities: ['24/7 Security', 'Generator', 'Swimming Pool'],
      ),
      Listing(
        id: '6',
        title: '5 Bedroom Mansionette',
        location: 'Asokoro, Abuja',
        pricePerAnnum: 25000000,
        bedrooms: 5,
        bathrooms: 5,
        imageUrls: ['https://picsum.photos/id/106/800/600', 'https://picsum.photos/id/1074/800/600'],
        description: 'Luxurious 5 bedroom mansionette with ample space.',
        landlordPhone: '2347012345678',
        availableFrom: DateTime.now().add(const Duration(days: 30)),
        amenities: ['Private Pool', 'Gym', 'Smart Home'],
      ),
      Listing(
        id: '7',
        title: '2 Bedroom Bungalow',
        location: 'Life Camp, Abuja',
        pricePerAnnum: 7200000,
        bedrooms: 2,
        bathrooms: 2,
        imageUrls: ['https://picsum.photos/id/175/800/600', 'https://picsum.photos/id/133/800/600'],
        description: 'Nice bungalow with compound space.',
        landlordPhone: '2347087654321',
        availableFrom: DateTime.now().add(const Duration(days: 12)),
        amenities: ['Compound', 'Generator', 'Security'],
      ),
      Listing(
        id: '8',
        title: 'Semi-Detached 3 Bedroom',
        location: 'Jahi, Abuja',
        pricePerAnnum: 10800000,
        bedrooms: 3,
        bathrooms: 3,
        imageUrls: ['https://picsum.photos/id/106/800/600', 'https://picsum.photos/id/201/800/600'],
        description: 'Semi-detached unit in a quiet neighborhood.',
        landlordPhone: '2348091234567',
        availableFrom: DateTime.now().add(const Duration(days: 18)),
        amenities: ['Parking', 'Tiled floors', 'Security'],
      ),
      Listing(
        id: '9',
        title: 'Studio Apartment',
        location: 'Utako, Abuja',
        pricePerAnnum: 2400000,
        bedrooms: 1,
        bathrooms: 1,
        imageUrls: ['https://picsum.photos/id/133/800/600', 'https://picsum.photos/id/175/800/600'],
        description: 'Compact studio perfect for young professionals.',
        landlordPhone: '2347065432109',
        availableFrom: DateTime.now().add(const Duration(days: 5)),
        amenities: ['Security', 'Kitchenette', 'Water Heater'],
      ),
    ];
  }
}