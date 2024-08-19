import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_location_stream.g.dart';

@riverpod
Stream<Position> userLocationStream(UserLocationStreamRef ref) {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    ),
  );
}
