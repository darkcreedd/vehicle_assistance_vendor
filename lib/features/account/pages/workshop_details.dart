import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:vehicle_assistance_vendor/shared/providers/account_provider.dart';
import '/features/account/pages/reviews_page.dart';
import '/features/services/add_services_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'workshop_edit_page.dart';

class MyWorkShopPage extends ConsumerWidget {
  const MyWorkShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUserData = ref.read(accountProvider).value;

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CloseButton(),
        titleTextStyle:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        title: const Text("My Workshop"),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: ListView(
          controller: ModalScrollController.of(context),
          padding: const EdgeInsets.only(top: 16),
          children: [
            CachedNetworkImage(
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: 270,
              imageUrl: appUserData?.image ?? "",
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appUserData?.workshopName ?? "",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionChip(
                        label: const Text("4.5"),
                        backgroundColor: theme.colorScheme.secondaryContainer
                            .withOpacity(0.5),
                        avatar: const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        side: BorderSide(width: 0, color: Colors.grey.shade400),
                        onPressed: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const ReviewsPage();
                            },
                          );
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                                context: context,
                                builder: (_) => const AddServicesPage());
                          },
                          child: const Text("Edit Services"))
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Working Days",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(((appUserData?.openingdates['startDay'] !=
                          appUserData?.openingdates['endDay']))
                      ? "${appUserData?.openingdates['startDay']}  -  ${appUserData?.openingdates['endDay']}"
                      : "${appUserData?.openingdates['startDay']}s only")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                "Working Hours",
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                children: [
                  Text(
                      "${appUserData?.openingdates['startTime']} - ${appUserData?.openingdates['endTime']}"),
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: FilledButton.icon(
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                        context: context,
                        builder: (_) => const WorkShopEditPage());
                  },
                  label: const Text("Edit"),
                  icon: const Icon(IconlyBold.edit),
                ))
          ],
        ),
      ),
    );
  }
}

Future<String> getAddressFromLatLng(double? latitude, double? longitude) async {
  if (latitude == null || longitude == null) {
    return "Unknown location";
  }

  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  Placemark place = placemarks[0];

  return "${place.street ?? ""}, ${place.subLocality ?? ""}, ${place.locality ?? ""},${place.country}"
      .trim()
      .replaceAll(RegExp(r'^,|,$'), '');
}
