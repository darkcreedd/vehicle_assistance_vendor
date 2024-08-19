import 'package:cloud_firestore/cloud_firestore.dart';

import 'vehicle.dart';

class AUser {
  final String id;
  final String name;
  final String phone;

  final Timestamp createdAt;

  final Vehicle? vehicle;

  final double latitude;
  final double longitude;

  AUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.createdAt,
    this.vehicle,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'AppUser{id: $id, name: $name, phone: $phone, createdAt: $createdAt, vehicle: $vehicle}';
  }

  String get initials {
    return name.split(" ").map((e) => e[0]).join();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'createdAt': createdAt,
      'vehicle': vehicle?.toMap(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory AUser.fromMap(Map<String, dynamic> map) {
    return AUser(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      createdAt: map['createdAt'] as Timestamp,
      longitude: map['longitude'] as double,
      latitude: map['latitude'] as double,
      vehicle: map['vehicle'] != null
          ? Vehicle.fromMap(map['vehicle'] as Map<String, dynamic>)
          : null,
    );
  }

  factory AUser.initial() {
    return AUser(
      id: "",
      name: "Refresh",
      phone: "refresh to get",
      createdAt: Timestamp.now(),
      vehicle: null,
      latitude: 0.0,
      longitude: 0.0,
    );
  }

  AUser copyWith({
    String? id,
    String? name,
    String? phone,
    Timestamp? createdAt,
    Vehicle? vehicle,
    double? latitude,
    double? longitude,
  }) {
    return AUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      vehicle: vehicle ?? this.vehicle,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
