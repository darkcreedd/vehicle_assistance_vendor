class Vehicle {
  final String brand;
  final String model;
  final FuelType fuel;

  final String numberPlate;

  final String color;

  const Vehicle({
    required this.brand,
    required this.model,
    required this.fuel,
    required this.numberPlate,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'fuel': fuel,
      'numberPlate': numberPlate,
      'color': color,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      brand: map['brand'] as String,
      model: map['model'] as String,
      fuel: map['fuel'] as FuelType,
      numberPlate: map['numberPlate'] as String,
      color: map['color'] as String,
    );
  }

  factory Vehicle.initial() {
    return const Vehicle(
      brand: '',
      model: '',
      fuel: FuelType.diesel,
      numberPlate: '',
      color: '',
    );
  }
}

enum FuelType { diesel, petrol, electric }

enum GearType { manual, automatic }
