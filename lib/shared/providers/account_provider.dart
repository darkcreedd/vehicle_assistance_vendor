import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vehicle_assistance_vendor/shared/entities/service_provider.dart';

import '../../../shared/utils/constants.dart';

part 'account_provider.g.dart';

@riverpod
class Account extends _$Account {
  @override
  FutureOr<ServiceProvider> build() async {
    final userDoc =
        db.collection('serviceProviders').doc(auth.currentUser!.uid);
    final userSnapshot = await userDoc.get();
    debugPrint("user snapshot exists: ${userSnapshot.exists}");
    if (userSnapshot.exists) {
      return ServiceProvider.fromMap(userSnapshot.data()!);
    }
    return ServiceProvider.initial();
  }

  Future<void> createProfile(ServiceProvider user) async {
    final userDoc = db.collection('serviceProviders').doc(user.userId);
    await userDoc.set(user.toMap());
    state = AsyncData(user);
  }

  Future<void> updateProfile(ServiceProvider user) async {
    final userDoc = db.collection('serviceProviders').doc(user.userId);
    await userDoc.update(user.toMap());
    state = AsyncData(user);
  }

  Future<void> updateServices(List<String> services) async {
    final userDoc =
        db.collection('serviceProviders').doc(auth.currentUser!.uid);
    final userSnapshot = await userDoc.get();
    final serviceProvider = ServiceProvider.fromMap(userSnapshot.data()!);
    final updatedServiceProvider = serviceProvider.copyWith(services: services);
    await userDoc.update(updatedServiceProvider.toMap());
    state = AsyncData(updatedServiceProvider);
  }

  Future<void> updateProfileFields({
    String? imagePath,
    Map<String, dynamic>? openingDates,
  }) async {
    final userDoc =
        db.collection('serviceProviders').doc(auth.currentUser!.uid);
    final userSnapshot = await userDoc.get();
    final serviceProvider = ServiceProvider.fromMap(userSnapshot.data()!);

    final updatedServiceProvider = serviceProvider.copyWith(
      image: imagePath ?? serviceProvider.image,
      openingdates: openingDates ?? serviceProvider.openingdates,
    );

    await userDoc.update(updatedServiceProvider.toMap());
    state = AsyncData(updatedServiceProvider);
  }
}
