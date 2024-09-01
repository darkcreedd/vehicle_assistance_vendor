// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vehicle_assistance_vendor/features/onboarding/pages/set_workshop_details.page.dart';
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
        debugPrint("from account_setup_page $e");
      });
    });
  }

  File? image;
  String? imagePath;

  final ImagePicker _picker = ImagePicker();

  Future<void> selectImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  bool isLoading = false;

  Future<String> uploadImageToFirebase(File image) async {
    final context = formKey.currentContext;
    try {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("IDCards/${DateTime.now().microsecondsSinceEpoch}.png");
      await reference.putFile(image).whenComplete(() {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 2000),
              content: const Text("Image captured"),
              backgroundColor: Colors.green.withOpacity(.8),
            ),
          );
        }
      });
      return await reference.getDownloadURL();
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text(
                "An error occured while saving selected image,try again later."),
          ),
        );
      }
      rethrow;
    }
  }

  String fullName = "";
  String workShopName = "";
  String phoneNumber =
      FirebaseAuth.instance.currentUser?.phoneNumber ?? "050 0000000";
  String serviceType = "Mechanic";

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
              "Let's take you through the steps for registration.",
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text("Complete these tasks to get the most out of this app"),
            const Text(
                "This information will be shared with all customers in need of your assistance."),
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
                        "Workshop Information",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please enter your Workshop name"
                            : null;
                      },
                      onChanged: (value) => workShopName = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: "Workshop Name",
                        hintText: "KNUST Mechanic Shop",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        "Verification Information",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    //TODO:take Ghana card details
                    (image == null)
                        ? Text(
                            "Upload a picture of your ID card. This is for verification purposes only and will not be shared with the general public.",
                            style: theme.textTheme.bodySmall?.copyWith(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "This is image is only for verification purposes and will not be shared with the general public.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                    (image == null)
                        ? GestureDetector(
                            onTap: selectImageFromGallery,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DottedBorder(
                                dashPattern: const [3],
                                borderType: BorderType.RRect,
                                color: Colors.cyan.shade900,
                                radius: const Radius.circular(12),
                                padding: const EdgeInsets.all(6),
                                child: SizedBox(
                                  height: 80,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        MdiIcons.fileImageOutline,
                                        size: 30,
                                      ),
                                      Text(
                                        "Select image from gallery",
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImageFromGallery,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                              width: double.infinity,
                              height: 200,
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.maxFinite,
          child: FilledButton.icon(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (fullName.isEmpty ||
                    workShopName.isEmpty ||
                    serviceType.isEmpty ||
                    image == null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                          content: Text("Please fill in all fields")),
                    );
                  return;
                }
                print(
                    "from account setup page $fullName $phoneNumber $workShopName");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkShopSetupPage(
                      fullName: fullName,
                      phoneNumber: phoneNumber,
                      workshopName: workShopName,
                      type: serviceType,
                      idImage: image!,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                        content: Text("Please fill in all fields correctly")),
                  );
              }
            },
            label: const Text("Next"),
            icon: const Icon(IconlyBold.arrowRight),
          ),
        ),
      ),
    );
  }
}
