import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/entities/emergency_request.dart';
import '../../../shared/utils/constants.dart';

part 'emergency_request_provider.g.dart';

@riverpod
// ignore: camel_case_types
class onGoingEmergency extends _$onGoingEmergency {
  @override
  Stream<EmergencyRequest?> build() async* {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    yield* db
        .collection('emergencyRequests')
        .where('providerId', isEqualTo: userId)
        .where("status", isNotEqualTo: EmergencyStatus.rejected.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      return EmergencyRequest.fromMap(doc.data());
    });
  }

  Future<void> acceptEmergency(EmergencyRequest request) async {
    await db.collection('emergencyRequests').doc(request.id).update({
      'status':
          EmergencyStatus.accepted.name, // Update the status to 'rejected'
    });
  }

  Future<void> cancelEmergency(EmergencyRequest request) async {
    await db.collection('emergencyRequests').doc(request.id).update({
      'status':
          EmergencyStatus.rejected.name, // Update the status to 'rejected'
    });
  }
}
