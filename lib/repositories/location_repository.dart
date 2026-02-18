import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/doctor_info.dart';

class LocationRepository {
  static final String _googleMapsApiKey =
      dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<List<DoctorInfo>> findNearbyDoctors({
    double? latitude,
    double? longitude,
    double radiusInKm = 10.0,
  }) async {
    Position? position;

    // If coordinates not provided, get current location
    if (latitude == null || longitude == null) {
      position = await getCurrentLocation();
      latitude = position.latitude;
      longitude = position.longitude;
    }

    try {
      final radiusInMeters = radiusInKm * 1000;

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$latitude,$longitude'
        '&radius=$radiusInMeters'
        '&type=doctor'
        '&keyword=dermatologist'
        '&key=$_googleMapsApiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final results = data['results'] as List;

          return results
              .map(
                (json) => DoctorInfo.fromGooglePlaces(
                  json as Map<String, dynamic>,
                  latitude!,
                  longitude!,
                ),
              )
              .toList()
            ..sort((a, b) => a.distance.compareTo(b.distance));
        } else if (data['status'] == 'ZERO_RESULTS') {
          return [];
        } else {
          throw Exception('Error from Google Places API: ${data['status']}');
        }
      } else {
        throw Exception(
          'Failed to load nearby doctors: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error finding nearby doctors: $e');
    }
  }

  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=$latitude,$longitude'
        '&key=$_googleMapsApiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'] as String;
        }
      }

      return 'Address not available';
    } catch (e) {
      return 'Address not available';
    }
  }

  Future<bool> checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
