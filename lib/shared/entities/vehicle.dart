class Vehicle {
  final String brand;
  final String model;
  final String? year;
  final String fuel;
  final String gear;

  final String numberPlate;

  final String color;

  const Vehicle({
    required this.brand,
    required this.model,
    required this.fuel,
    required this.year,
    required this.gear,
    required this.numberPlate,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'fuel': fuel,
      'year': year ?? '2020',
      'gear': gear,
      'numberPlate': numberPlate,
      'color': color,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      brand: map['brand'] as String,
      model: map['model'] as String,
      gear: map['gear'] as String,
      year: map['year'] ?? '2020',
      fuel: map['fuel'] as String,
      numberPlate: map['numberPlate'] as String,
      color: map['color'] as String,
    );
  }

  factory Vehicle.initial() {
    return Vehicle(
      brand: '',
      model: '',
      year: '',
      gear: '',
      fuel: '${FuelType.diesel}',
      numberPlate: '',
      color: '',
    );
  }
}

enum FuelType { diesel, petrol, electric }

enum GearType { manual, automatic }
