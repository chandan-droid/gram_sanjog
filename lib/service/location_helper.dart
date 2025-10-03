import 'dart:math';
import 'package:geohash_plus/geohash_plus.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import '../model/location_details.dart';

class LocationHelper {
  static Future<LocationDetails> getCurrentLocation() async {
    final location = loc.Location();

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw 'Location service is disabled';
        }
      }

      loc.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          throw 'Location permission denied';
        }
      }

      final locationData = await location.getLocation();

      if (locationData.latitude == null || locationData.longitude == null) {
        throw 'Could not get location coordinates';
      }

      final List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isEmpty) {
        throw 'Could not determine location details';
      }

      final place = placemarks.first;

      // Create geohash string
      final geohash = GeoHash.encode(
        locationData.latitude!,
        locationData.longitude!,
        precision: 9,  // Changed to 9 for better area representation
      ).hash;

      return LocationDetails(
        area: place.subLocality ?? place.locality ?? 'Unknown Area',
        city: place.locality ?? place.subAdministrativeArea ?? 'Unknown City',
        state: place.administrativeArea ?? 'Unknown State',
        pincode: place.postalCode ?? 'Unknown',
        landmark: place.name ?? '',
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        geohash: geohash,
        block: place.subAdministrativeArea ?? '',
        district: place.subAdministrativeArea ?? '',
        address: [
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
          place.postalCode,
        ].where((e) => e != null && e.isNotEmpty).join(', '),
      );
    } catch (e) {
      throw 'Error getting location: $e';
    }
  }

  static String generateGeohash(double latitude, double longitude, {int precision = 9}) {
    // Validate latitude and longitude
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude must be between -90 and 90 degrees.');
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude must be between -180 and 180 degrees.');
    }
    if (precision < 1 || precision > 12) {
      throw ArgumentError('Precision must be between 1 and 12.');
    }
    return GeoHash.encode(latitude, longitude, precision: precision).hash;
  }

  static Map<String, double> getCoordinatesFromGeohash(String geohash) {
    try {
      final decoded = GeoHash.decode(geohash);
      // GeoHash.decode returns a GeoHash object, which has a LatLng center property
      return {
        'latitude': decoded.center.latitude,
        'longitude': decoded.center.longitude,
      };
    } catch (e) {
      throw 'Invalid geohash: $e';
    }
  }

  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    try {
      // Implementation of Haversine formula for distance calculation
      // Returns distance in kilometers
      const R = 6371; // Earth's radius in kilometers

      // Convert to radians
      final lat1Rad = _toRadians(lat1);
      final lon1Rad = _toRadians(lon1);
      final lat2Rad = _toRadians(lat2);
      final lon2Rad = _toRadians(lon2);

      final dLat = lat2Rad - lat1Rad;
      final dLon = lon2Rad - lon1Rad;

      final a = pow(sin(dLat / 2), 2) +
          cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);

      final c = 2 * asin(sqrt(a));
      return R * c;
    } catch (e) {
      throw 'Error calculating distance: $e';
    }
  }

  static double _toRadians(double degree) {
    return degree * (pi / 180.0);
  }
}
