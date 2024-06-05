import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '/shared/widgets/bottom_sheet_appbar.dart';
import '../../../shared/providers/location_provider.dart';

class LocationPage extends ConsumerStatefulWidget {
  const LocationPage({super.key});

  @override
  ConsumerState createState() => _LocationPageState();
}

class _LocationPageState extends ConsumerState<LocationPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Marker? _selectedMarker;

  Future<void> goToMyLocation() async {
    final location = ref.read(locationProvider);
    final controller = await _controller.future;
    if (location.value == null) return;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.value!.latitude, location.value!.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> _onMapTap(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark placemark =
        placemarks.isNotEmpty ? placemarks[0] : const Placemark();

    String address =
        '${placemark.street ?? ''}, ${placemark.subLocality ?? ''}, ${placemark.locality ?? ''}, '
        '${placemark.administrativeArea ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}';

    setState(() {
      _selectedMarker = Marker(
        markerId: const MarkerId('selectedPoint'),
        position: position,
        infoWindow: InfoWindow(title: 'Selected Point', snippet: address),
      );
    });
    print(address);
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    return Scaffold(
      appBar: bottomSheetAppBar(context, "My Location"),
      body: location.when(
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        data: (value) => GoogleMap(
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          buildingsEnabled: true,
          compassEnabled: false,
          rotateGesturesEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 18.4746,
          ),
          onTap: _onMapTap,
          markers: _selectedMarker != null ? {_selectedMarker!} : {},
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconlyLight.location,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Text(
                "Please allow location access",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToMyLocation,
        child: const Icon(IconlyLight.location),
      ),
    );
  }
}
