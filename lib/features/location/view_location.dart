import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vehicle_assistance_vendor/shared/utils/constants.dart';

import '../../shared/entities/emergency_request.dart';
import '../../shared/providers/account_provider.dart';
import 'providers/service_provider_location_stream.dart';
import 'providers/user_location_stream.dart';

class ViewLocationOnMap extends ConsumerStatefulWidget {
  const ViewLocationOnMap({super.key, required this.emergencyRequest});

  final EmergencyRequest emergencyRequest;

  @override
  ConsumerState createState() => _EmergencyTrackingPageState();
}

class _EmergencyTrackingPageState extends ConsumerState<ViewLocationOnMap> {
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
      ), // Replace with your API key
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

  @override
  Widget build(BuildContext context) {
    final userLocationAsync = ref.watch(userLocationStreamProvider);
    final providerLocationAsync = ref.watch(
        serviceProviderLocationStreamProvider(
            widget.emergencyRequest.providerId));
    final appUserData = ref.read(accountProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text("Get to ${widget.emergencyRequest.providerName}"),
      ),
      body: providerLocationAsync.when(
        data: (providerLocation) {
          return userLocationAsync.when(
            data: (userPosition) {
              final userLocation =
                  LatLng(userPosition.latitude, userPosition.longitude);
              _updateMapState(userLocation, providerLocation);
              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: userLocation,
                      zoom: 14,
                    ),
                    markers: _markers,
                    polylines: _polylines,
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
              return const Center(
                child: CupertinoActivityIndicator(),
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
