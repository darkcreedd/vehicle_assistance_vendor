import 'package:flutter/material.dart';
import '/shared/widgets/bottom_sheet_appbar.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bottomSheetAppBar(context, "Running Service"),
    );
  }
}
