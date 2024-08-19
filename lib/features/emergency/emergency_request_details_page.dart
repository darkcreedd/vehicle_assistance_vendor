import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '/features/booking/providers/emergency_request_provider.dart';
import '/features/location/emergency_tracking_page.dart';
import '../account/pages/workshop_details.dart';
import '/features/booking/providers/emergency_user_stream.dart';
import '/shared/entities/emergency_request.dart';
import '../../../shared/widgets/bottom_sheet_appbar.dart';
import '../../shared/entities/user.dart';

class EmergencyRequestDetailsPage extends ConsumerWidget {
  const EmergencyRequestDetailsPage(
      {super.key, required this.emergencyDetails});
  final EmergencyRequest emergencyDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;
    final onGoingEmergency = ref.read(onGoingEmergencyProvider.notifier);
    final AsyncValue<AUser> userAsync =
        ref.watch(emergencyUserStreamProvider(emergencyDetails.userId));
    return Scaffold(
      appBar: bottomSheetAppBar(context, "Emergency Request Details"),
      body: switch (userAsync) {
        AsyncLoading() => const Center(
            child: CupertinoActivityIndicator(),
          ),
        AsyncError(:final error) => Center(child: Text(error.toString())),
        AsyncData(value: final user) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(user.name.substring(0, 1)),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name),
                        Text(user.phone),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Emergency",
                  style:
                      theme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(emergencyDetails.description),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Vehicle",
                  style:
                      theme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                    '${user.vehicle?.year} ${user.vehicle?.brand} ${user.vehicle?.model}'),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Additional Vehicle Info",
                  style:
                      theme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                    'Gear: ${user.vehicle?.gear} \nFuel type: ${user.vehicle?.fuel}'),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Emergency Status",
                  style:
                      theme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(emergencyDetails.status.name),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Location Requested from",
                  style:
                      theme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                FutureBuilder<String>(
                  future: getAddressFromLatLng(user.latitude, user.longitude),
                  builder: (context, snapshot) {
                    print("lat ${user.latitude} long ${user.longitude}");
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
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                        try {
                          await onGoingEmergency
                              .acceptEmergency(emergencyDetails);
                          if (!context.mounted) return;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmergencyTrackingPage(
                                    emergencyRequest: emergencyDetails),
                              ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      },
                      label: const Text("Accept Emergency")),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: OutlinedButton.icon(
                    icon: const Icon(IconlyLight.call),
                    onPressed: () async {
                      launchUrlString('tel:${user.phone}');
                    },
                    label: Text("Call ${user.name}"),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: OutlinedButton.icon(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            titleTextStyle: theme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            title: const Text("Cancel Request"),
                            content: const Text(
                                "Are you sure you want to cancel this request?"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      await onGoingEmergency
                                          .cancelEmergency(emergencyDetails);
                                      if (!context.mounted) return;

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(e.toString())));
                                    }
                                  },
                                  child: const Text("Yes")),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"))
                            ],
                          ),
                        );
                      },
                      label: Text(
                        "Decline Emergency",
                        style: theme.bodyMedium!.copyWith(color: Colors.red),
                      )),
                )
              ],
            )),
        _ => const CupertinoActivityIndicator(),
      },
    );
  }
}
