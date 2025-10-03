import 'package:location/location.dart' as loc;
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

      return LocationDetails(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        district: '',
        block: '',
        gpWard: '',
        villageStreet: '',
        state: '',
      );
    } catch (e) {
      throw 'Error getting location: $e';
    }
  }
}
