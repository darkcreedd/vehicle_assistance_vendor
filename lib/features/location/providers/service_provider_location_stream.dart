import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_provider_location_stream.g.dart';

@riverpod
class ServiceProviderLocationStream extends _$ServiceProviderLocationStream {
  @override
  Stream<LatLng> build(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data != null &&
          data['latitude'] != null &&
          data['longitude'] != null) {
        return LatLng(data['latitude'], data['longitude']);
      }
      throw Exception('Invalid service provider location data');
    });
  }
}
