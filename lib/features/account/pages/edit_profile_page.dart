import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../shared/widgets/bottom_sheet_appbar.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: bottomSheetAppBar(context, "Update Your Profile"),
      body: ListView(
        controller: ModalScrollController.of(context),
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "NAME",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          TextFormField(
            initialValue: "Jeron",
          ),
          const SizedBox(height: 16),
          Text(
            "PHONE NUMBER",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          TextFormField(
            initialValue: "+233 55 555 5555",
            readOnly: true,
          ),
          const SizedBox(height: 16),
          Text(
            "OTHER PHONE NUMBER(OPTIONAL)",
            style: theme.textTheme.bodyMedium,
          ),
          TextFormField(
            initialValue: "+233 00 000 0000",
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
