import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_assistance_vendor/shared/entities/service_provider.dart';

class AppUserDataNotifier extends StateNotifier<ServiceProvider> {
  AppUserDataNotifier()
      : super(ServiceProvider(
          userId: '',
          name: '',
          workshopName: '',
          phone: '',
          latitude: 0,
          longitude: 0,
          image: '',
          openingdates: {},
          services: [],
        ));

  void setAppUserData(ServiceProvider workshopDetails) {
    state = workshopDetails;
  }
}

final appUserDataProvider =
    StateNotifierProvider<AppUserDataNotifier, ServiceProvider>((ref) {
  return AppUserDataNotifier();
});
