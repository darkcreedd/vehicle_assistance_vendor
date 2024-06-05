import 'package:flutter/material.dart';

import '../../../shared/widgets/bottom_sheet_appbar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bottomSheetAppBar(context, "About Us"),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Mechanease Vendor",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Text("Version 1.0.0"),
            const Text("Developed by"),
          ],
        ),
      ),
    );
  }
}
