import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String title;
  final String location;
  final double pricePerAnnum;        // Changed to yearly
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
}