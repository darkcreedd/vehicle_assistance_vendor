import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' show Lottie;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vehicle_assistance_vendor/shared/utils/constants.dart';

import '../../shared/entities/emergency_request.dart';
import '../booking/providers/emergency_request_provider.dart';
import 'providers/service_provider_location_stream.dart';
import 'providers/user_location_stream.dart';

class EmergencyTrackingPage extends ConsumerStatefulWidget {
  const EmergencyTrackingPage({super.key, required this.emergencyRequest});

  final EmergencyRequest emergencyRequest;

  @override
  ConsumerState createState() => _EmergencyTrackingPageState();
}

class _EmergencyTrackingPageState extends ConsumerState<EmergencyTrackingPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  void _updateMarkers(LatLng userLocation, LatLng? providerLocation) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('user'),
          position: userLocation,
          infoWindow: const InfoWindow(
            title: "Your Location",
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
        if (providerLocation != null)
          Marker(
            markerId: const MarkerId('provider'),
            infoWindow: InfoWindow(
              title: "${widget.emergencyRequest.providerName} Location",
            ),
            position: providerLocation,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
      };
    });
  }

  void _updateCamera(LatLng userLocation, LatLng providerLocation) {
    final bounds = LatLngBounds(
      southwest: LatLng(
        userLocation.latitude < providerLocation.latitude
            ? userLocation.latitude
            : providerLocation.latitude,
        userLocation.longitude < providerLocation.longitude
            ? userLocation.longitude
            : providerLocation.longitude,
      ),
      northeast: LatLng(
        userLocation.latitude > providerLocation.latitude
            ? userLocation.latitude
            : providerLocation.latitude,
        userLocation.longitude > providerLocation.longitude
            ? userLocation.longitude
            : providerLocation.longitude,
      ),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  Future<void> _updatePolylines(LatLng start, LatLng end) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleMapKey,
      request: PolylineRequest(
        origin: PointLatLng(start.latitude, start.longitude),
        destination: PointLatLng(end.latitude, end.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            points: polylineCoordinates,
            width: 5,
          ),
        };
      });
    }
  }

  void _updateMapState(LatLng userLocation, LatLng? providerLocation) {
    _updateMarkers(userLocation, providerLocation);
    if (providerLocation != null) {
      _updateCamera(userLocation, providerLocation);
      _updatePolylines(userLocation, providerLocation);
    }
  }

  void onMorePressed() {
    final theme = Theme.of(context);
    final value = widget.emergencyRequest;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  "Your customer is waiting for your assistance.",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                const Text(
                  "Don't seem to find your customer?",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        launchUrlString("tel:${value.providerPhone}");
                      },
                      child: const Text("Call Now")),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref
                          .read(onGoingEmergencyProvider.notifier)
                          .cancelEmergency(value);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Emergency aborted.")));
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error),
                    child: const Text("Abort Emergency"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final myLocation = ref.watch(userLocationStreamProvider);
    final customerLocation = ref.watch(
        serviceProviderLocationStreamProvider(widget.emergencyRequest.userId));

    print("my location ${myLocation.value}");
    print("customer location ${customerLocation.value}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Navigate to your customer"),
        actions: [
          IconButton(
              onPressed: onMorePressed, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: customerLocation.when(
        data: (providerLocation) {
          return myLocation.when(
            data: (userPosition) {
              final userLocation =
                  LatLng(userPosition.latitude, userPosition.longitude);
              _updateMapState(userLocation, providerLocation);
              return Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    rotateGesturesEnabled: true,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    buildingsEnabled: true,
                    trafficEnabled: true,
                    compassEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: userLocation,
                      zoom: 14,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    mapToolbarEnabled: true,
                    tiltGesturesEnabled: true,
                    circles: {
                      Circle(
                        circleId: const CircleId("1"),
                        center: LatLng(
                            userPosition.latitude, userPosition.longitude),
                        radius: 40,
                        strokeWidth: 0,
                        fillColor: Colors.blue.withOpacity(0.2),
                        zIndex: 1000,
                      ),
                      Circle(
                        circleId: const CircleId("2"),
                        center: LatLng(providerLocation.latitude,
                            providerLocation.longitude),
                        radius: 40,
                        strokeWidth: 0,
                        fillColor: Colors.red.withOpacity(0.2),
                        zIndex: 1000,
                      ),
                    },
                    onMapCreated: (controller) => _mapController = controller,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Distance: ${Geolocator.distanceBetween(
                          userLocation.latitude,
                          userLocation.longitude,
                          providerLocation.latitude,
                          providerLocation.longitude,
                        ).toStringAsFixed(2)} meters',
                      ),
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () {
              return Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/tracking.json"),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Finding the best route to your customer...")
                    ]),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text("Something went wrong"),
          );
        },
        loading: () {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
