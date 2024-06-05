import 'package:cloud_firestore/cloud_firestore.dart';
import '/shared/entities/vehicle.dart';

class AppUser {
  final String id;
  final String name;
  final String phone;

  final Timestamp createdAt;

  final Vehicle? vehicle;

  AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.createdAt,
    this.vehicle,
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
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      createdAt: map['createdAt'] as Timestamp,
      vehicle: map['vehicle'] != null
          ? Vehicle.fromMap(map['vehicle'] as Map<String, dynamic>)
          : null,
    );
  }

  factory AppUser.initial() {
    return AppUser(
      id: "",
      name: "",
      phone: "",
      createdAt: Timestamp.now(),
      vehicle: null,
    );
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? phone,
    Timestamp? createdAt,
    Vehicle? vehicle,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      vehicle: vehicle ?? this.vehicle,
    );
  }
}
