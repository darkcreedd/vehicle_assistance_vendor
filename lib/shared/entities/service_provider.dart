import '/shared/entities/vehicle_service.dart';

class ServiceProvider {
  final String name;

  final String image;

  final List<VehicleService> services;

  ServiceProvider(
      {required this.name, required this.services, required this.image});
}
