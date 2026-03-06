import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  // Get current device location
  static Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // print('❌ Location services not enabled');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // print('❌ Location permission denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // print('❌ Location permission denied forever');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // print('✅ Got position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      // print('❌ Location error: $e');
      return null;
    }
  }

  // Convert coordinates to address using BigDataCloud API (FREE, NO CORS)
  static Future<Map<String, String?>?> getAddressFromCoordinates(
    double latitude, 
    double longitude
  ) async {
    try {
      print('🌍 Calling BigDataCloud API for: $latitude, $longitude');
      
      // Free API, no key required - 10,000 requests/day
      final url = 'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ BigDataCloud response received');
        
        // Parse the response
        String? street = data['street'] ?? '';
        String? locality = data['locality'] ?? data['neighbourhood'] ?? '';
        String? city = data['city'] ?? data['town'] ?? '';
        String? principalSubdivision = data['principalSubdivision'] ?? ''; // Province/Region
        
        // For Philippines, we need to map the data correctly
        String? barangay = locality;
        String? municipality = city;
        String? province = principalSubdivision;
        String? region = principalSubdivision; // May need mapping
        
        // Log for debugging
        // print('📍 BIGDATACLOUD RAW DATA:');
        // print('  countryName: ${data['countryName']}');
        // print('  principalSubdivision: ${data['principalSubdivision']}');
        // print('  city: ${data['city']}');
        // print('  locality: ${data['locality']}');
        // print('  street: ${data['street']}');
        // print('  postcode: ${data['postcode']}');
        
        // print('📍 PARSED ADDRESS:');
        // print('  Street: $street');
        // print('  Barangay: $barangay');
        // print('  Municipality: $municipality');
        // print('  Province: $province');
        // print('  Region: $region');
        
        return {
          'street': street ?? '',
          'barangay': barangay ?? '',
          'municipality': municipality ?? '',
          'province': province ?? '',
          'region': region ?? '',
          'country': data['countryName'] ?? '',
          'postalCode': data['postcode'] ?? '',
        };
      } else {
        print('❌ BigDataCloud API error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Reverse geocoding error: $e');
    }
    
    return null;
  }

  // Get both location and address
  static Future<Map<String, dynamic>?> getCurrentLocationWithAddress() async {
    try {
      final position = await getCurrentLocation();
      if (position == null) {
        // print('❌ Could not get position');
        return null;
      }

      final address = await getAddressFromCoordinates(
        position.latitude, 
        position.longitude
      );

      if (address == null) {
        // print('❌ Could not get address from coordinates');
      }

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
      };
    } catch (e) {
      // print('❌ Error getting location with address: $e');
      return null;
    }
  }
}

