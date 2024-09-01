import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_assistance_vendor/features/root_app_page.dart';

import '../../../shared/data/vehicle_service.dart';
import '../../../shared/widgets/bottom_sheet_appbar.dart';
import '../../shared/entities/vehicle_service.dart';
import '../../shared/providers/account_provider.dart';
import '../../shared/success_dialog.dart';

// ignore: must_be_immutable
class AddServicesPage extends ConsumerStatefulWidget {
  const AddServicesPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddServicesPageState();
}

class _AddServicesPageState extends ConsumerState<AddServicesPage> {
  List<String> selectedServices = [];

  void toggleSelection(VehicleService service) {
    setState(() {
      if (selectedServices.contains(service.name)) {
        selectedServices.remove(service.name);
      } else {
        selectedServices.add(service.name);
      }
    });
  }

  SnackBar snackBar = const SnackBar(
      content: Text("Please select 1 or more service(s) to proceed"));

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final serviceProvider = ref.read(accountProvider.notifier);
    // final user = ref.watch(accountProvider);

    return Scaffold(
      appBar: bottomSheetAppBar(context, "Add Services"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Re-select all the services you offer at your workshop"),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              width: double.maxFinite,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(
                  vehicleServices.length,
                  (index) => GestureDetector(
                    onTap: () {
                      toggleSelection(vehicleServices[index]);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: selectedServices
                                .contains(vehicleServices[index].name)
                            ? BorderSide(
                                width: 2, color: Theme.of(context).primaryColor)
                            : BorderSide(color: Colors.grey.shade300),
                      ),
                      child: InkWell(
                        onTap: () {
                          toggleSelection(vehicleServices[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child:
                                    Image.asset(vehicleServices[index].image),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  vehicleServices[index].description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 200,
              child: (isLoading)
                  ? const FilledButton(
                      onPressed: null,
                      child: CircularProgressIndicator.adaptive())
                  : FilledButton(
                      onPressed: () async {
                        // getSelectedServices();
                        if (selectedServices.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await serviceProvider
                                .updateServices(selectedServices);
                            if (!context.mounted) return;
                            showSuccessDialog(context).then(
                              (value) => Navigator.pushAndRemoveUntil(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RootAppPage()),
                                  (route) => false),
                            );
                          } catch (e) {
                            if (!context.mounted) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  content: Text(
                                      "Oops an error occured. Try again later"),
                                ),
                              );
                            }
                            return;
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                      child: Text(
                        "Save & Update",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
