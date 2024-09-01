import 'package:geocoding/geocoding.dart';

class ServiceProvider {
  final String userId;

  final String workshopName;

  final String name;

  final String image;

  final String idImage;

  final List<String> services;

  final double longitude;

  final double latitude;

  final String phone;

  final Map<String, dynamic> openingdates;

  String get openingDay {
    final startDay = openingdates['startDay'] as String;
    final endDay = openingdates['endDay'] as String;
    return '$startDay - $endDay';
  }

  String get openingTime {
    final startTime = openingdates['startTime'] as String;
    final endTime = openingdates['endTime'] as String;
    return '$startTime - $endTime';
  }

  Future<String> getLocation() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    final placemark = placemarks[0];
    return '${placemark.street}, ${placemark.locality}';
  }

  ServiceProvider({
    required this.name,
    required this.services,
    required this.image,
    required this.userId,
    required this.idImage,
    required this.longitude,
    required this.latitude,
    required this.phone,
    required this.openingdates,
    required this.workshopName,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'image': image,
      'idImage': idImage,
      'services': services,
      'longitude': longitude,
      'latitude': latitude,
      'phone': phone,
      'openingdates': openingdates,
      'workshopName': workshopName,
    };
  }

  factory ServiceProvider.fromMap(Map<String, dynamic> map) {
    return ServiceProvider(
      userId: map['userId'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      phone: map['phone'] as String,
      idImage: map['idImage'] as String,
      services: List<String>.from(map['services']),
      openingdates: map['openingdates'] as Map<String, dynamic>,
      workshopName: map['workshopName'] as String,
      longitude: double.parse(map['longitude'].toString()),
      latitude: double.parse(map['latitude'].toString()),
    );
  }
  factory ServiceProvider.initial() {
    return ServiceProvider(
      userId: "C5J159fpzqXaFAbrBFPGfLlCkW93",
      name: "Mainoo",
      image:
          "https://images.pexels.com/photos/8470886/pexels-photo-8470886.jpeg?auto=compress&cs=tinysrgb&w=800",
      phone: "0207644110",
      idImage: "",
      services: ['tyre', 'towing', 'engine', 'washing', 'fuel'],
      openingdates: {
        "startDay": "Mon",
        "endDay": "Fri",
        "startTime": "5:00 AM",
        "endTime": "Mon",
      },
      workshopName: "Def Services",
      longitude: 0,
      latitude: 0,
    );
  }

  ServiceProvider copyWith({
    String? userId,
    String? workshopName,
    String? name,
    String? image,
    String? idImage,
    List<String>? services,
    double? longitude,
    double? latitude,
    String? phone,
    Map<String, dynamic>? openingdates,
  }) {
    return ServiceProvider(
      userId: userId ?? this.userId,
      workshopName: workshopName ?? this.workshopName,
      name: name ?? this.name,
      image: image ?? this.image,
      idImage: idImage ?? this.image,
      services: services ?? this.services,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      phone: phone ?? this.phone,
      openingdates: openingdates ?? this.openingdates,
    );
  }
}
