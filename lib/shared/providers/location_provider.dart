import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/location.dart';
import '../utils/location.dart';
part 'location_provider.g.dart';

@riverpod
Future<MyLocation> location(Ref ref) async {
  final position = await determinePosition();
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  return MyLocation(
    latitude: position.latitude,
    longitude: position.longitude,
    city: placemarks[0].locality ?? '',
    state: placemarks[0].administrativeArea ?? '',
    country: placemarks[0].country ?? '',
    street: placemarks[0].street ?? '',
  );
}
