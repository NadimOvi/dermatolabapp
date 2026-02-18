import 'package:equatable/equatable.dart';

class DoctorInfo extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String address;
  final double latitude;
  final double longitude;
  final double distance; // in kilometers
  final double? rating;
  final int? totalRatings;
  final String? phoneNumber;
  final bool isOpenNow;
  final String? photoUrl;

  const DoctorInfo({
    required this.id,
    required this.name,
    required this.specialty,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.rating,
    this.totalRatings,
    this.phoneNumber,
    this.isOpenNow = false,
    this.photoUrl,
  });

  factory DoctorInfo.fromGooglePlaces(
    Map<String, dynamic> json,
    double userLat,
    double userLng,
  ) {
    final location = json['geometry']['location'];
    final lat = location['lat'] as double;
    final lng = location['lng'] as double;

    // Calculate distance using Haversine formula
    final distance = _calculateDistance(userLat, userLng, lat, lng);

    return DoctorInfo(
      id: json['place_id'] as String,
      name: json['name'] as String,
      specialty: 'Dermatologist',
      address:
          json['vicinity'] as String? ??
          json['formatted_address'] as String? ??
          'Address not available',
      latitude: lat,
      longitude: lng,
      distance: distance,
      rating: json['rating']?.toDouble(),
      totalRatings: json['user_ratings_total'] as int?,
      isOpenNow: json['opening_hours']?['open_now'] ?? false,
      photoUrl: json['photos'] != null && (json['photos'] as List).isNotEmpty
          ? json['photos'][0]['photo_reference']
          : null,
    );
  }

  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // in kilometers

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(lat1)) *
            _cos(_toRadians(lat2)) *
            _sin(dLon / 2) *
            _sin(dLon / 2);

    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) =>
      degrees * (3.141592653589793 / 180);
  static double _sin(double x) =>
      x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  static double _cos(double x) => 1 - (x * x) / 2 + (x * x * x * x) / 24;
  static double _sqrt(double x) {
    if (x == 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  static double _atan2(double y, double x) {
    if (x > 0) return _atan(y / x);
    if (x < 0 && y >= 0) return _atan(y / x) + 3.141592653589793;
    if (x < 0 && y < 0) return _atan(y / x) - 3.141592653589793;
    if (x == 0 && y > 0) return 3.141592653589793 / 2;
    if (x == 0 && y < 0) return -3.141592653589793 / 2;
    return 0;
  }

  static double _atan(double x) {
    return x - (x * x * x) / 3 + (x * x * x * x * x) / 5;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    specialty,
    address,
    latitude,
    longitude,
    distance,
    rating,
    totalRatings,
    phoneNumber,
    isOpenNow,
    photoUrl,
  ];
}
