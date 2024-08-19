import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../shared/providers/account_provider.dart';
import '/features/services/add_services_page.dart';
import '/shared/data/vehicle_service.dart';

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(accountProvider);
    print(user.value?.services);
    print(user.value);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Services"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: switch (user) {
          AsyncLoading() => const Center(
              child: CupertinoActivityIndicator(),
            ),
          AsyncError(:final error) => Center(child: Text(error.toString())),
          AsyncData(value: final user) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Services Offered"),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: user.services.map((serviceName) {
                        final service = vehicleServices.firstWhere(
                            (vehicleService) =>
                                vehicleService.name == serviceName);
                        return Card.outlined(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(child: Image.asset(service.image)),
                                Text(
                                  service.description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          _ => const CupertinoActivityIndicator(),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalBottomSheet(
              context: context, builder: (_) => const AddServicesPage());
        },
        child: const Icon(IconlyLight.edit),
      ),
    );
  }
}
