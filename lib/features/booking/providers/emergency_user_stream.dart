import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/entities/user.dart';

part 'emergency_user_stream.g.dart';

@riverpod
class EmergencyUserStream extends _$EmergencyUserStream {
  @override
  Stream<AUser> build(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        return AUser.fromMap(data);
      }
      throw Exception('Invalid user details');
    });
  }
}
