import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:vehicle_assistance_vendor/features/onboarding/pages/onboarding_add_services_page.dart';
import 'package:vehicle_assistance_vendor/shared/entities/service_provider.dart';
import '../../../shared/providers/set_location_provider.dart';
import '../../../shared/providers/location_provider.dart';

final googleMapControllerProvider =
    Provider<Completer<GoogleMapController>>((ref) {
  return Completer<GoogleMapController>();
});

// ignore: must_be_immutable
class LocationPage extends ConsumerStatefulWidget {
  ServiceProvider serviceProviderDetails;

  LocationPage({super.key, required this.serviceProviderDetails});

  @override
  ConsumerState<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends ConsumerState<LocationPage> {
  late final Completer<GoogleMapController> _controllerCompleter;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controllerCompleter = Completer<GoogleMapController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      goToMyLocation();
    });
  }

  @override
  void dispose() {
    _controllerCompleter.future.then((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> goToMyLocation() async {
    final location = ref.read(locationProvider);
    // if (location.value == null) {
    //   _showSnackBar("Unable to get current location.");
    //   return;
    // }

    final controller = await _controllerCompleter.future;
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
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      ref.read(placemarkProvider.notifier).state = placemarks;

      Placemark placemark =
          placemarks.isNotEmpty ? placemarks[0] : const Placemark();

      String address = [
        placemark.street,
        placemark.subLocality,
        placemark.locality,
        placemark.administrativeArea,
        placemark.postalCode,
        placemark.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      ref.read(selectedMarkerProvider.notifier).state = Marker(
        markerId: const MarkerId('selectedPoint'),
        position: position,
        infoWindow: InfoWindow(title: 'Selected Point', snippet: address),
      );

      debugPrint(
          'Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      debugPrint('Address: $address');
    } catch (e) {
      debugPrint('Error in _onMapTap: $e');
      _showSnackBar("Failed to get address for selected location.");
    }
  }

  void updateWorkShop() {
    final selectedMarker = ref.read(selectedMarkerProvider);
    if (selectedMarker != null) {
      widget.serviceProviderDetails = widget.serviceProviderDetails.copyWith(
        phone: FirebaseAuth.instance.currentUser?.phoneNumber,
        latitude: selectedMarker.position.latitude,
        longitude: selectedMarker.position.longitude,
      );
      debugPrint(
          "Updated workshop details: ${widget.serviceProviderDetails.toMap()}");
    } else {
      _showSnackBar("Please select a location on the map.");
    }
  }

  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState
        ?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    final selectedMarker = ref.watch(selectedMarkerProvider);
    final placemarks = ref.watch(placemarkProvider);

    var theme = Theme.of(context);

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const CloseButton(),
          titleTextStyle: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          title: const Text("Set Location"),
        ),
        body: location.when(
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          data: (value) => GoogleMap(
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            buildingsEnabled: true,
            compassEnabled: false,
            rotateGesturesEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controllerCompleter.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              // target: LatLng(6.6700696479255495, -1.55816949256451),

              target: LatLng(value.latitude, value.longitude),
              zoom: 18.4746,
            ),
            onTap: _onMapTap,
            markers: selectedMarker != null ? {selectedMarker} : {},
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(IconlyLight.location,
                    size: 100, color: theme.colorScheme.primary),
                const SizedBox(height: 10),
                Text("Please allow location access",
                    style: theme.textTheme.titleMedium),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (placemarks.isNotEmpty)
                Text(
                  "${placemarks[0].street ?? ""}\n${placemarks.first.locality},${placemarks.first.administrativeArea},${placemarks.first.country}",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              else
                const Text(
                    "Use the location button to move to your location.\nPinpoint your location on the map by single tapping\nDouble tap to zoom in (+)\nScroll left or right to view more"),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() => _isLoading = true);
                            updateWorkShop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OnboardingAddServicesPage(
                                  workshopDetails:
                                      widget.serviceProviderDetails,
                                ),
                              ),
                            ).then((_) => setState(() => _isLoading = false));
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : const Text("Next"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
