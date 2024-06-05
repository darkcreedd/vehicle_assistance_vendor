import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/shared/widgets/bottom_sheet_appbar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: bottomSheetAppBar(context, "Notifications"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.bell, size: 60),
            const SizedBox(height: 10),
            Text(
              "You're up to date!",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text("Check back later for updates",
                style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
