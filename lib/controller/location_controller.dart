import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  final loc.Location _location = loc.Location();

  RxBool isServiceEnabled = false.obs;
  RxBool isPermissionGranted = false.obs;
  Rx<loc.LocationData?> currentLocation = Rx<loc.LocationData?>(null);

  RxString currentPincode = ''.obs;
  RxString currentArea = ''.obs;
  RxString currentCity = ''.obs;
  RxString currentState = ''.obs;


  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          error.value = 'Location service is disabled.';
          return;
        }
      }
      isServiceEnabled.value = true;

      loc.PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          error.value = 'Location permission denied.';
          return;
        }
      }
      isPermissionGranted.value = true;

      loc.LocationData locationData = await _location.getLocation();
      currentLocation.value = locationData;

      if (locationData.latitude != null && locationData.longitude != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          currentPincode.value = place.postalCode ?? 'Unknown';
          currentArea.value = place.subLocality ?? place.street ?? 'Unknown Area';
          currentCity.value = place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
          currentState.value = place.administrativeArea ?? 'Unknown State';
        }
      }

      if (kDebugMode) {
        print("📍 Latitude: ${locationData.latitude}");
        print("📍 Longitude: ${locationData.longitude}");
        print("🏙️ City: ${currentCity.value}");
        print("🗺️ State: ${currentState.value}");
        print("📮 Pin Code: ${currentPincode.value}");
      }
    } catch (e) {
      error.value = 'Error fetching location: $e';
    }
  }
}
