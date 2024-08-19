import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_assistance_vendor/features/root_app_page.dart';
import 'package:vehicle_assistance_vendor/shared/entities/service_provider.dart';

import '../../../shared/data/vehicle_service.dart';
import '../../../shared/entities/vehicle_service.dart';
import '../../../shared/widgets/bottom_sheet_appbar.dart';

// ignore: must_be_immutable
class OnboardingAddServicesPage extends ConsumerStatefulWidget {
  OnboardingAddServicesPage({super.key, required this.workshopDetails});

  ServiceProvider workshopDetails;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingAddServicesPageState();
}

class _OnboardingAddServicesPageState
    extends ConsumerState<OnboardingAddServicesPage> {
  bool isLoading = false;
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

  void getSelectedServices() {
    if (widget.workshopDetails.services.isEmpty) {
      widget.workshopDetails =
          widget.workshopDetails.copyWith(services: selectedServices);
    } else {
      // Handle the case where widget.workshopDetails is null
    }
    debugPrint(
        "from onboarding_add_services_page selected indices $selectedServices");
    debugPrint("updated workshop details ${widget.workshopDetails.toMap()}");
  }

  SnackBar snackBar = const SnackBar(
    content: Text("Please select 1 or more service(s) to proceed"),
  );

  Future<void> writeWorkshopDetailsToServiceProviders() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await firestore
          .collection('serviceProviders')
          .doc(widget.workshopDetails.userId)
          .set(widget.workshopDetails.toMap());
    } else {
      debugPrint('User is not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bottomSheetAppBar(context, "Add Services"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Select the services you offer at your workshop"),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              itemCount: vehicleServices.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 120,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: selectedServices.contains(vehicleServices[index].name)
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
                            child: Image.asset(vehicleServices[index].image),
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
                );
              },
            ),
            SizedBox(
              width: double.maxFinite,
              child: FilledButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        getSelectedServices();
                        if (selectedServices.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          print(widget.workshopDetails.toMap());
                          print(selectedServices);
                          writeWorkshopDetailsToServiceProviders();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RootAppPage()),
                              (route) => false);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Finish"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
