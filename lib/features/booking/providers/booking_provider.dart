import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/entities/booking.dart';
import '../../../shared/utils/constants.dart';

part 'booking_provider.g.dart';

@riverpod
class Appointments extends _$Appointments {
  @override
  Stream<List<Booking>> build() async* {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    yield* db
        .collection('bookings')
        .where('providerId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Booking.fromMap(doc.data())).toList();
      }
      return [];
    });
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    final booking = db.collection('bookings').doc(bookingId);
    await booking.update(
        {'status': BookingStatus.cancelled.name, 'cancellationReason': reason});
    debugPrint("finished updating booking");
    ref.invalidateSelf();
  }

  Future<void> acceptBooking(String bookingId) async {
    debugPrint("state: ${state.value}");
    debugPrint("bookingId: $bookingId");
    final booking = db.collection('bookings').doc(bookingId);
    await booking.update({'status': BookingStatus.confirmed.name});
    debugPrint("finished updating booking");
    ref.invalidateSelf();
  }
}
