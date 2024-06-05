class VehicleService {
  final String name;

  final String image;

  VehicleService({required this.name, required this.image});
}

extension VehicleServiceExtension on VehicleService {
  String get title {
    switch (name) {
      case "Towing":
        return "Towing Vehicles";
      case "Tyre":
        return "Tyre Repairs";
      case "Engine":
        return "Engine Workshops";
      case "Battery":
        return "Battery Repairs";
      case "Fuel":
        return "Fuel Stations";
      case "Fire":
        return "Fire Services";
      default:
        return "Other";
    }
  }
}
