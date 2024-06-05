import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/shared/entities/vehicle.dart';
import '/shared/utils/location.dart';

import '../../../shared/utils/constants.dart';
import '../../root_app_page.dart';

class AccountSetupPage extends ConsumerStatefulWidget {
  const AccountSetupPage({super.key});

  @override
  ConsumerState createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends ConsumerState<AccountSetupPage> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      determinePosition().then((value) => print(value)).catchError((e) {
        print(e);
      });
    });
  }

  String fullName = "";
  String brand = "";
  String model = "";
  String numberPlate = "";
  String color = "";

  FuelType fuel = FuelType.petrol;
  GearType gear = GearType.manual;

  Future<void> setupAccount() async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text("Please fill in all fields")),
        );
      return;
    }
    if (auth.currentUser == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text("Please login first")),
        );
      return;
    }
    // final user = AppUser(
    //   id: auth.currentUser!.uid,
    //   name: fullName,
    //   phone: auth.currentUser!.phoneNumber!,
    //   createdAt: Timestamp.now(),
    //   vehicle: Vehicle(
    //       brand: brand,
    //       model: model,
    //       numberPlate: numberPlate,
    //       color: color,
    //       fuel: fuel),
    // );
    // ref.read(accountProvider.notifier).createProfile(user);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const RootAppPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
          children: [
            Text(
              "Finish Account Setup",
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text("Complete these tasks to get the most out of this app"),
            const Text(
                "This information will be shared with Emergency Assistance and shop owners when you book appointments"),
            const SizedBox(height: 30),
            ChipTheme(
              data: theme.chipTheme.copyWith(
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelStyle: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                showCheckmark: false,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Personal Information",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please enter your full name"
                            : null;
                      },
                      onChanged: (value) => fullName = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        hintText: "Your full name",
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      readOnly: true,
                      initialValue:
                          FirebaseAuth.instance.currentUser?.phoneNumber ??
                              "0544751048",
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        hintText: "Your phone number",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Text(
                        "Vehicle Information",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please enter your vehicle brand"
                            : null;
                      },
                      onChanged: (value) => brand = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: "Brand",
                        hintText: "Eg. Honda, Toyota, Kia",
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please enter your vehicle model"
                            : null;
                      },
                      onChanged: (value) => model = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: "Model",
                        hintText: "Eg. Civic, Corolla, K5",
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please enter your vehicle number plate"
                            : null;
                      },
                      onChanged: (value) => numberPlate = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: "Number Plate",
                        hintText: "Eg. GT-4332",
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please enter your vehicle color"
                            : null;
                      },
                      onChanged: (value) => color = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: "Color",
                        hintText: "Eg. Black, White, Silver",
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip(
                          label: Text(FuelType.petrol.name),
                          selected: fuel == FuelType.petrol,
                          onSelected: (value) {
                            setState(() {
                              fuel = FuelType.petrol;
                            });
                          },
                          avatar: const Icon(Icons.local_gas_station),
                        ),
                        ChoiceChip(
                          label: Text(FuelType.diesel.name),
                          selected: fuel == FuelType.diesel,
                          onSelected: (value) {
                            setState(() {
                              fuel = FuelType.diesel;
                            });
                          },
                          avatar: const Icon(Icons.local_gas_station),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip(
                          label: Text(GearType.automatic.name),
                          selected: gear == GearType.automatic,
                          onSelected: (value) {
                            setState(() {
                              gear = GearType.automatic;
                            });
                          },
                          avatar: const Icon(Icons.settings),
                        ),
                        ChoiceChip(
                          label: Text(GearType.manual.name),
                          selected: gear == GearType.manual,
                          onSelected: (value) {
                            setState(() {
                              gear = GearType.manual;
                            });
                          },
                          avatar: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
                onPressed: setupAccount,
                label: const Text("Finish"),
                icon: const Icon(IconlyBold.arrowRight))
          ],
        ),
      ),
    );
  }
}
