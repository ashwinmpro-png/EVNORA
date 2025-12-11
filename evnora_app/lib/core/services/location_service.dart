import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

import 'storage_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final currentLocationProvider = FutureProvider<LocationData?>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.getCurrentLocation();
});

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check and request location permission
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // Open app settings (for permission)
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  // Get current location
  Future<LocationData?> getCurrentLocation({
    bool highAccuracy = false,
  }) async {
    try {
      // Check if location is enabled in app settings
      if (!StorageService.isLocationEnabled()) {
        return null;
      }

      // Check if location services are enabled
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permission
      var permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: highAccuracy
              ? LocationAccuracy.high
              : LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 15),
        ),
      );

      // Get address from coordinates
      final address = await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Get last known location (faster, may be less accurate)
  Future<LocationData?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return null;

      final address = await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      print('Error getting last known location: $e');
      return null;
    }
  }

  // Get address from coordinates
  Future<AddressData?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      return AddressData(
        street: place.street,
        subLocality: place.subLocality,
        locality: place.locality,
        administrativeArea: place.administrativeArea,
        postalCode: place.postalCode,
        country: place.country,
        countryCode: place.isoCountryCode,
        formattedAddress: _formatAddress(place),
      );
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  // Get coordinates from address
  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      print('Error getting coordinates: $e');
      return [];
    }
  }

  // Calculate distance between two points
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  // Stream location updates
  Stream<Position> getLocationStream({
    int distanceFilter = 100,
    bool highAccuracy = false,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy:
            highAccuracy ? LocationAccuracy.high : LocationAccuracy.medium,
        distanceFilter: distanceFilter,
      ),
    );
  }

  // Format address
  String _formatAddress(Placemark place) {
    final parts = <String>[];
    
    if (place.street != null && place.street!.isNotEmpty) {
      parts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      parts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      parts.add(place.locality!);
    }
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      parts.add(place.administrativeArea!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      parts.add(place.postalCode!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      parts.add(place.country!);
    }

    return parts.join(', ');
  }
}

// Location data model
class LocationData {
  final double latitude;
  final double longitude;
  final AddressData? address;
  final DateTime timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    required this.timestamp,
  });

  String get formattedAddress => address?.formattedAddress ?? 'Unknown location';

  String get shortAddress {
    if (address == null) return 'Unknown';
    final parts = <String>[];
    if (address!.locality != null) parts.add(address!.locality!);
    if (address!.country != null) parts.add(address!.country!);
    return parts.join(', ');
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address?.formattedAddress,
        'timestamp': timestamp.toIso8601String(),
      };
}

// Address data model
class AddressData {
  final String? street;
  final String? subLocality;
  final String? locality;
  final String? administrativeArea;
  final String? postalCode;
  final String? country;
  final String? countryCode;
  final String formattedAddress;

  AddressData({
    this.street,
    this.subLocality,
    this.locality,
    this.administrativeArea,
    this.postalCode,
    this.country,
    this.countryCode,
    required this.formattedAddress,
  });
}

// Permission status helper
class LocationPermissionStatus {
  static Future<bool> hasPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  static Future<bool> requestPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> isPermanentlyDenied() async {
    final status = await Permission.location.status;
    return status.isPermanentlyDenied;
  }
}
