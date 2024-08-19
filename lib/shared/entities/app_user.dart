import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String phone;

  final Timestamp createdAt;

  // final WorkShop? workShop;

  AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.createdAt,
    // this.workShop,
  });

  @override
  String toString() {
    return 'AppUser{id: $id, name: $name, phone: $phone, createdAt: $createdAt, }';
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
      // 'workShop': workShop
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      createdAt: map['createdAt'] as Timestamp,
      // workShop: map['workShop']
    );
  }

  factory AppUser.initial() {
    return AppUser(
      id: "",
      name: "",
      phone: "",
      createdAt: Timestamp.now(),
      // workShop: null,
    );
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? phone,
    Timestamp? createdAt,
    // WorkShop? vehicle,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      // workShop: workShop ?? workShop,
    );
  }
}
