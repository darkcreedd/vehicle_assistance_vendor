import 'package:flutter/material.dart';

import '../../../shared/widgets/bottom_sheet_appbar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: bottomSheetAppBar(context, "About Us"),
      body: SizedBox(
        width: mediaQ.width,
        height: mediaQ.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 150,
                width: 1500,
                child: Image.asset("assets/app_logo.png")),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Mechanease Vendor",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Text("Version 1.0.0"),
            const Text("Developed by"),
            Text(
              "Ofosu Effah Samuel & Tetteh Asiedu Jeron",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
