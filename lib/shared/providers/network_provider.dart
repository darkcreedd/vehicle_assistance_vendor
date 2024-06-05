import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

@riverpod
Future<bool> hasInternet(HasInternetRef ref) async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  return connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi);
}
