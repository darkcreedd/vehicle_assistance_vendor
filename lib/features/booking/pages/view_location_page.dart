import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:vehicle_assistance_vendor/shared/utils/constants.dart';

final currentPositionProvider = StateProvider<Position?>((ref) => null);

class LiveTrackingMap extends ConsumerStatefulWidget {
  final double sourceLatitude;
  final double sourceLongitude;
  final double destinationLatitude;
  final double destinationLongitude;

  const LiveTrackingMap({
    super.key,
    required this.sourceLatitude,
    required this.sourceLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  @override
  LiveTrackingMapState createState() => LiveTrackingMapState();
}

class LiveTrackingMapState extends ConsumerState<LiveTrackingMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};
  final PolylinePoints _polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addMarkers();
    _addCircle();
    _getDirections();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    ref.read(currentPositionProvider.notifier).state = position;
    _updateCameraPosition();
  }

  void _addMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('source'),
        position: LatLng(widget.sourceLatitude, widget.sourceLongitude),
        infoWindow: const InfoWindow(title: 'Source'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position:
            LatLng(widget.destinationLatitude, widget.destinationLongitude),
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );
  }

  void _addCircle() {
    _circles.add(
      Circle(
        circleId: const CircleId("source_circle"),
        center: LatLng(widget.sourceLatitude, widget.sourceLongitude),
        radius: 50,
        strokeWidth: 0,
        fillColor: Colors.blue.withOpacity(0.2),
        zIndex: 1000,
      ),
    );
  }

  void _getDirections() async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${widget.sourceLatitude},${widget.sourceLongitude}'
        '&destination=${widget.destinationLatitude},${widget.destinationLongitude}'
        '&key=$googleMapKey';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _addPolyline(data);
    } else {
      debugPrint('Failed to get directions: ${response.statusCode}');
    }
  }

  void _addPolyline(dynamic data) {
    if (data['routes'].isEmpty) return;

    String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
    List<PointLatLng> decodedPolyline =
        _polylinePoints.decodePolyline(encodedPolyline);

    List<LatLng> polylineCoordinates = decodedPolyline
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
        ),
      );
    });

    _fitMapToPolyline(polylineCoordinates);
  }

  void _fitMapToPolyline(List<LatLng> polylineCoordinates) {
    if (_mapController == null) return;

    double minLat = polylineCoordinates.first.latitude;
    double maxLat = polylineCoordinates.first.latitude;
    double minLng = polylineCoordinates.first.longitude;
    double maxLng = polylineCoordinates.first.longitude;

    for (var point in polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50, // padding
      ),
    );
  }

  void _updateCameraPosition() {
    final currentPosition = ref.read(currentPositionProvider);
    if (currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentPosition.latitude, currentPosition.longitude),
        ),
      );
    }
  }

  bool isZoomed = true;

  @override
  Widget build(BuildContext context) {
    // final currentPosition = ref.watch(currentPositionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Directions to Username')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          tilt: 20,
          target: LatLng(widget.sourceLatitude, widget.sourceLongitude),
          zoom: 18.4746,
        ),
        markers: _markers,
        polylines: _polylines,
        circles: _circles,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        compassEnabled: false,
        buildingsEnabled: true,
        trafficEnabled: true,
      ),
    );
  }
}
