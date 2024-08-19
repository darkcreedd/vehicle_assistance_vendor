import 'package:intl/intl.dart';
import '/shared/entities/vehicle.dart';

class Booking {
  final String id;
  final String userId;
  final String providerId;

  final String? cancellationReason;

  final String phoneNumber;

  final String? imageUrl;

  final String userName;
  final String date;
  final String time;

  final String description;

  final Vehicle vehicle;

  final String workshopName;

  final String workshopImage;

  final String workshopPhone;
  final double workshopLong;

  final double workshopLat;

  final double userLong;
  final double userLat;

  final BookingStatus status;

  String get bookingDate {
    final newDate = DateTime.parse(date);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final newDateAsYear = DateTime(newDate.year, newDate.month, newDate.day);

    if (newDateAsYear == today) {
      return 'Today';
    } else if (newDateAsYear == tomorrow) {
      return 'Tomorrow';
    } else {
      final formatter =
          DateFormat('EEE d, yyyy'); // Example format: Tue 20, 2024
      return formatter.format(newDate);
    }
  }

  const Booking({
    required this.userId,
    required this.id,
    required this.providerId,
    required this.date,
    required this.time,
    required this.description,
    required this.workshopName,
    required this.workshopImage,
    this.status = BookingStatus.pending,
    required this.workshopPhone,
    required this.workshopLong,
    required this.workshopLat,
    required this.vehicle,
    required this.userName,
    required this.phoneNumber,
    required this.userLong,
    required this.userLat,
    this.imageUrl,
    this.cancellationReason,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'providerId': providerId,
      'date': date,
      'time': time,
      'description': description,
      'id': id,
      'workshopName': workshopName,
      'workshopImage': workshopImage,
      'status': status.name,
      'workshopPhone': workshopPhone,
      'workshopLong': workshopLong,
      'workshopLat': workshopLat,
      'vehicle': vehicle.toMap(),
      'userName': userName,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'cancellationReason': cancellationReason,
      'userLong': userLong,
      'userLat': userLat,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      userId: map['userId'] as String,
      id: map['id'] as String,
      providerId: map['providerId'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      description: map['description'] as String,
      workshopName: map['workshopName'] as String,
      workshopImage: map['workshopImage'] as String,
      status: BookingStatus.values.byName(map['status'] as String),
      workshopPhone: map['workshopPhone'] as String,
      workshopLong: map['workshopLong'] as double,
      workshopLat: map['workshopLat'] as double,
      vehicle: Vehicle.fromMap(map['vehicle'] as Map<String, dynamic>),
      userName: map['userName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      imageUrl: map['imageUrl'] as String?,
      cancellationReason: map['cancellationReason'] as String?,
      userLong: map['userLong'] as double,
      userLat: map['userLat'] as double,
    );
  }

  copyWith({
    String? id,
    String? userId,
    String? providerId,
    String? date,
    String? time,
    String? service,
    String? workshopName,
    String? workshopImage,
    BookingStatus? status,
    String? workshopPhone,
    double? workshopLong,
    double? workshopLat,
    Vehicle? vehicle,
    String? userName,
    String? phoneNumber,
    String? imageUrl,
    String? cancellationReason,
    double? userLong,
    double? userLat,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      date: date ?? this.date,
      time: time ?? this.time,
      description: service ?? description,
      workshopName: workshopName ?? this.workshopName,
      workshopImage: workshopImage ?? this.workshopImage,
      status: status ?? this.status,
      workshopPhone: workshopPhone ?? this.workshopPhone,
      workshopLong: workshopLong ?? this.workshopLong,
      workshopLat: workshopLat ?? this.workshopLat,
      vehicle: vehicle ?? this.vehicle,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      userLong: userLong ?? this.userLong,
      userLat: userLat ?? this.userLat,
    );
  }
}

enum BookingStatus { pending, confirmed, cancelled, past }
