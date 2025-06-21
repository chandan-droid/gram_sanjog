import 'package:flutter/foundation.dart';
import 'package:geohash_plus/geohash_plus.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

import '../model/news_model.dart';

class LocationController extends GetxController {
  final loc.Location _location = loc.Location();
  final NewsController newsController = Get.put(NewsController());


  RxBool isServiceEnabled = false.obs;
  RxBool isPermissionGranted = false.obs;
  Rx<loc.LocationData?> currentLocation = Rx<loc.LocationData?>(null);

  RxString currentPincode = ''.obs;
  RxString currentArea = ''.obs;
  RxString currentCity = ''.obs;
  RxString currentState = ''.obs;


  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) { // if location service is not enabled, request for location service
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {//if still not enabled, throw the error message
          errorMessage.value = 'Location service is disabled.';
          return;
        }
      }
      isServiceEnabled.value = true;

      loc.PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          errorMessage.value = 'Location permission denied.';
          return;
        }
      }
      isPermissionGranted.value = true;

      loc.LocationData locationData = await _location.getLocation();
      currentLocation.value = locationData;

      if (locationData.latitude != null && locationData.longitude != null) {
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );

        if (placemarks.isNotEmpty) {
          geo.Placemark place = placemarks.first;
          currentPincode.value = place.postalCode ?? 'Unknown';
          currentArea.value = place.subLocality ?? place.street ?? 'Unknown Area';
          currentCity.value = place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
          currentState.value = place.administrativeArea ?? 'Unknown State';
          final geohash = GeoHash.encode( locationData.latitude!,locationData.longitude!, precision: 12);
          if (kDebugMode) {
            print('Geohash: $geohash');
          }

        }
      }

      if (kDebugMode) {
        print("Latitude: ${locationData.latitude}");
        print("Longitude: ${locationData.longitude}");
        print("area: ${currentArea.value}");
        print("City: ${currentCity.value}");
        print("State: ${currentState.value}");
        print("Pin Code: ${currentPincode.value}");
      }
    } catch (e) {
      errorMessage.value = 'Error fetching location.';
    }
  }

  Future<void> geohashFromLocationData(LocationDetails? location) async {
    if (location == null) return;
    String address = [
      location.gp,
      location.block != null ? '${location.block} Block' : null,
      location.district,
      location.state,
      location.country
    ].where((e) => e != null && e.trim().isNotEmpty).join(', ');

    if (kDebugMode) {
      print('Formatted address: $address');
    }

    try {
      List<geo.Location> locations = await geo.locationFromAddress(address);

      if (locations.isNotEmpty) {
        double lat = locations.first.latitude;
        double lon = locations.first.longitude;

        var geohash = GeoHash.encode(lat, lon, precision: 7);
        if (kDebugMode) {
          print(" location : $address");
          print("📍 Coordinates: ($lat, $lon)");
          print("🌐 Geohash: $geohash");
        }


      } else {
        if (kDebugMode) {
          print("⚠️ Could not find location for the given address.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error: $e");
      }
    }

    // Optional: You can geocode address -> coordinates -> geohash, if needed
  }
}
