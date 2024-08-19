import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vehicle_assistance_vendor/shared/utils/constants.dart';

import '../../../shared/utils/location.dart';

class CustomerLocationPage extends ConsumerStatefulWidget {
  const CustomerLocationPage({
    super.key,
    required this.workshopLat,
    required this.workshopLong,
    required this.userName,
    required this.userLat,
    required this.userLong,
  });

  final double workshopLat;
  final double workshopLong;

  final double userLat;
  final double userLong;
  final String userName;

  @override
  ConsumerState createState() => _ProvidersLocationPageState();
}

class _ProvidersLocationPageState extends ConsumerState<CustomerLocationPage> {
  final _controller = Completer<GoogleMapController>();
  final polylinePoints = PolylinePoints();

  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  Future<Set<Polyline>> getPolyLines() async {
    Set<Polyline> polylines = {};
    final position = await determinePosition();
    final results = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleMapKey,
      request: PolylineRequest(
        origin: PointLatLng(widget.workshopLat, widget.workshopLong),
        destination: PointLatLng(position.latitude, position.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (results.points.isNotEmpty) {
      final polyline = Polyline(
        polylineId: const PolylineId('1'),
        color: Colors.blue,
        width: 4,
        points:
            results.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      );
      polylines.add(polyline);
    }
    return polylines;
  }

  @override
  void initState() {
    super.initState();
    markers.add(
      Marker(
        infoWindow: InfoWindow(title: widget.userName),
        markerId: const MarkerId('1'),
        position: LatLng(widget.workshopLat, widget.workshopLong),
      ),
    );
    markers.add(
      Marker(
        markerId: const MarkerId('2'),
        infoWindow: const InfoWindow(title: 'My Location'),
        position: LatLng(widget.userLat, widget.userLong),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPolyLines().then((value) {
        setState(() {
          polylines = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direction to ${widget.userName}'),
      ),
      body: GoogleMap(
        zoomControlsEnabled: true,
        fortyFiveDegreeImageryEnabled: true,
        zoomGesturesEnabled: true,
        markers: markers,
        polylines: polylines,
        buildingsEnabled: true,
        compassEnabled: false,
        rotateGesturesEnabled: true,
        trafficEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.userLat, widget.userLong),
          zoom: 18.4746,
        ),
      ),
    );
  }
}
