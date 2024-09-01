import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vehicle_assistance_vendor/features/booking/pages/bookings_page.dart';
import 'package:vehicle_assistance_vendor/features/emergency/emergency_request_details_page.dart';
import 'package:vehicle_assistance_vendor/shared/providers/bottom_tab_provider.dart';

import '../shared/entities/emergency_request.dart';
import '../shared/providers/account_provider.dart';
import 'account/pages/account_page.dart';
import 'booking/providers/emergency_request_provider.dart';
import 'home/pages/home_page.dart';
import 'location/emergency_tracking_page.dart';
import 'location/providers/location_updater.dart';
import 'notification/firebase_notification.dart';
import 'services/services_page.dart';

class RootAppPage extends ConsumerStatefulWidget {
  const RootAppPage({super.key});

  @override
  ConsumerState createState() => _RootAppPageState();
}

class _RootAppPageState extends ConsumerState<RootAppPage> {
  // int currentIndex = 0;

  final pages = const [
    HomePage(),
    BookingsPage(),
    ServicesPage(),
    AccountPage()
  ];

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "review",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    debugPrint("interactive notification received");
    final type = message.data['type'];
    if (type == 'CANCELLED') {
      messenger.showSnackBar(const SnackBar(
          content: Text("A booking with you has been cancelled.")));
    } else if (type == 'EMERGENCY') {
      messenger.showSnackBar(const SnackBar(
          content: Text("You have received an emergency request.")));
    } else {
      messenger.showSnackBar(const SnackBar(
          content: Text("You received a notification while you were away.")));
    }
  }

  Future<void> setupForegroundMessage() async {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final type = message.data['type'];
      if (type == 'CANCELLED') {
        messenger.showSnackBar(const SnackBar(
            content: Text("A booking with you has been cancelled")));
      } else if (type == 'EMERGENCY') {
        messenger.showSnackBar(const SnackBar(
            content: Text("You have received an emergency notification.")));
      } else {
        messenger.showSnackBar(const SnackBar(
            content: Text("You received a notification while you were away.")));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    FCMFunctions.retrieveAndSaveFCMToken();
    setupInteractedMessage();
    setupForegroundMessage();
  }

  onEmergencyListTileTap(EmergencyRequest value) {
    final theme = Theme.of(context);
    if (value.status == EmergencyStatus.pending) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    "Someone urgently needs your help. Tap to view the details of this emergency.",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmergencyRequestDetailsPage(
                                  emergencyDetails: value),
                            ),
                          );
                        },
                        child: const Text("View Emergency Details")),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        ref
                            .read(onGoingEmergencyProvider.notifier)
                            .cancelEmergency(value);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.error),
                      child: const Text("Abort Emergency"),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EmergencyTrackingPage(emergencyRequest: value),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final emergencyRequests = ref.watch(onGoingEmergencyProvider);
    final currentIndex = ref.watch(bottomTabProvider);
    ref.watch(locationUpdaterProvider);
    final theme = Theme.of(context);
    ref.watch(accountProvider);

    return Scaffold(
      bottomSheet: switch (emergencyRequests) {
        AsyncData(:final value) => value == null
            ? null
            : SizedBox(
                height: 70,
                child: ListTile(
                  onTap: () async {
                    onEmergencyListTileTap(value);
                  },
                  trailing: Icon(Icons.crisis_alert,
                      color: value.status == EmergencyStatus.pending
                          ? Colors.red
                          : Colors.green),
                  titleTextStyle: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade200)),
                  leading: const CircleAvatar(
                    child: Icon(Icons.notifications_on_outlined),
                  ),
                  title: Text(
                    value.status == EmergencyStatus.pending
                        ? "A customer needs your help, tap to here to know what they need"
                        : "Carefully follow the map to get to your customer",
                  ),
                  subtitle: value.status == EmergencyStatus.accepted
                      ? const Text("Tap to track")
                      : null,
                ),
              ),
        _ => const SizedBox.shrink(),
      },
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: ref.read(bottomTabProvider.notifier).setTab,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            activeIcon: Icon(IconlyBold.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(IconlyLight.calendar),
            activeIcon: Icon(IconlyBold.calendar),
            label: "Schedules",
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.tools),
            activeIcon: Icon(MdiIcons.tools),
            label: "Services",
          ),
          const BottomNavigationBarItem(
            icon: Icon(IconlyLight.profile),
            activeIcon: Icon(IconlyBold.profile),
            label: "Account",
          )
        ],
      ),
    );
  }
}
