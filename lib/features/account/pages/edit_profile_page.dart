import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vehicle_assistance_vendor/shared/entities/service_provider.dart';

import '../../../shared/providers/account_provider.dart';
import '../../../shared/success_dialog.dart';
import '../../../shared/widgets/bottom_sheet_appbar.dart';
import 'workshop_details.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(accountProvider);
    final appUserData = ref.read(accountProvider).value;

    String name = '';

    return Scaffold(
      appBar: bottomSheetAppBar(context, "Update Your Profile"),
      body: switch (user) {
        AsyncData(value: ServiceProvider user) => ListView(
            controller: ModalScrollController.of(context),
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                "NAME",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              TextFormField(
                onChanged: (value) => name = value,
                initialValue: user.name,
              ),
              const SizedBox(height: 16),
              Text(
                "PHONE NUMBER",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              TextFormField(
                initialValue: user.phone,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              Text(
                "ADDRESS",
                style: theme.textTheme.bodyMedium,
              ),
              FutureBuilder<String>(
                future: getAddressFromLatLng(
                  appUserData?.latitude ?? 0,
                  appUserData?.longitude ??
                      0, // added default value for longitude
                ),
                builder: (context, snapshot) {
                  print(
                      "lat ${appUserData?.latitude} long ${appUserData?.latitude}");
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!); // added null safety
                    } else {
                      print(snapshot.error);
                      return const Text("No data");
                    }
                  } else {
                    return const Text("Loading...");
                  }
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content: Text("Name cannot be empty"),
                      ));
                    return;
                  }
                  final updatedUser = user.copyWith(name: name);
                  ref.read(accountProvider.notifier).updateProfile(updatedUser);
                  showSuccessDialog(context)
                      .then((value) => Navigator.pop(context));
                },
                child: const Text("Update"),
              ),
            ],
          ),
        AsyncLoading() => const Center(child: CupertinoActivityIndicator()),
        _ => const Center(child: CupertinoActivityIndicator()),
      },
    );
  }
}
