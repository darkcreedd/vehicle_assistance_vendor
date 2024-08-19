import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_assistance_vendor/shared/providers/appdata_provider.dart';

import '../entities/service_provider.dart';

Future<void> fetchWorkshopDetailsAndUser(
    BuildContext context, WidgetRef ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final doc = await FirebaseFirestore.instance
        .collection('serviceProviders')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final serviceProvider =
          ServiceProvider.fromMap(doc.data()!['workshopDetails']);
      ref.read(appUserDataProvider.notifier).setAppUserData(serviceProvider);

      debugPrint(
          'Workshop Details from firebase_data_provider: $serviceProvider');
      debugPrint('User Details: ${doc.data()}');
    } else {
      debugPrint('No workshop details found for user');
    }
  } else {
    debugPrint('User is not authenticated');
  }
}
