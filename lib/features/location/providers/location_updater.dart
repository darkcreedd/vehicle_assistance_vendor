import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_updater.g.dart';

@riverpod
class LocationUpdater extends _$LocationUpdater {
  static const double _significantDistance = 5; // meters
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;

  @override
  void build() {
    // Initialize
    _startLocationUpdates();

    // Cancel subscription when the provider is disposed
    ref.onDispose(() {
      _positionStream?.cancel();
    });
  }

  void _startLocationUpdates() async {
    // Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user denies permission
        return;
      }
    }

    // Start listening to location changes
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: _significantDistance.toInt(),
      ),
    ).listen(_handleLocationUpdate);
  }

  void _handleLocationUpdate(Position position) async {
    if (_lastPosition == null ||
        Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              position.latitude,
              position.longitude,
            ) >=
            _significantDistance) {
      await _updateUserLocation(position);
      _lastPosition = position;
    }
  }

  Future<void> _updateUserLocation(Position position) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        FirebaseFirestore.instance.collection('serviceProviders').doc(userId);

    final docSnapshot = await userDoc.get();
    if (docSnapshot.exists) {
      await userDoc.update({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } else {
      // Handle the case where the document does not exist
      print('Document does not exist');
    }
  }
}
