import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../features/home/pages/location_page.dart';
import '../features/home/pages/notifications_page.dart';
import 'account/pages/account_page.dart';
import 'home/pages/home_page.dart';
import 'services/services_page.dart';

class RootAppPage extends StatefulWidget {
  const RootAppPage({super.key});

  @override
  State<RootAppPage> createState() => _RootAppPageState();
}

class _RootAppPageState extends State<RootAppPage> {
  int currentIndex = 0;
  final pages = const [HomePage(), ServicesPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ActionChip(
          label: const Text("Accra, Ghana"),
          backgroundColor:
              theme.colorScheme.secondaryContainer.withOpacity(0.5),
          avatar: const Icon(IconlyLight.location),
          side: BorderSide(width: 0, color: Colors.grey.shade400),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationPage(),
                ));
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) {
                  return const NotificationsPage();
                },
              );
            },
            icon: Badge(
              backgroundColor: theme.colorScheme.primary,
              alignment: const Alignment(1, -1.5),
              child: const Icon(IconlyLight.notification),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedIndex: currentIndex,
        destinations: [
          const NavigationDestination(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(MdiIcons.tools),
            label: 'Services',
          ),
          const NavigationDestination(
            icon: Icon(CupertinoIcons.person),
            label: 'Account',
          ),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
