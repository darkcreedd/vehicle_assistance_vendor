import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final selectedMarkerProvider = StateProvider<Marker?>((ref) {
  return null;
});

final placemarkProvider = StateProvider<List<Placemark>>((ref) {
  return [];
});
