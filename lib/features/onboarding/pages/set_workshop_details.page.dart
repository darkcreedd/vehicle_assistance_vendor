import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vehicle_assistance_vendor/shared/utils/constants.dart';

import '../../../shared/entities/service_provider.dart';
import '../widgets/workshop_timepicker.dart';
import 'location_page.dart';

class WorkShopSetupPage extends StatefulWidget {
  const WorkShopSetupPage({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.workshopName,
    required this.type,
  });

  final String fullName;
  final String phoneNumber;
  final String workshopName;
  final String type;

  @override
  State<WorkShopSetupPage> createState() => WorkShopSetupPageState();
}

class WorkShopSetupPageState extends State<WorkShopSetupPage> {
  final GlobalKey<WorkShopSetupPageState> scaffoldKey = GlobalKey();

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

  Future<void> uploadImageToFirebase(File image) async {
    final context = scaffoldKey.currentContext;
    try {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("workShopImages/${DateTime.now().microsecondsSinceEpoch}.png");
      await reference.putFile(image).whenComplete(() {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 2000),
              content: const Text("Image captured"),
              backgroundColor: Colors.green.withOpacity(.8),
            ),
          );
        }
      });
      imagePath = await reference.getDownloadURL();
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text(
                "An error occured while saving selected image,try again later."),
          ),
        );
      }
    }
  }

  final Map<String, bool> _isSelected = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  TimeOfDay openingTime = const TimeOfDay(hour: 6, minute: 00);
  TimeOfDay closingTime = const TimeOfDay(hour: 18, minute: 00);

  String startDay = "Mon";
  String endDay = "Fri";

  Map<String, String> structure = {
    "startDay": "Mon",
    "endDay": "Thur",
    "startTime": "8:00AM",
    "endTime": "17:00AM"
  };

  void setDays() {
    structure = {
      "startDay": _isSelected.keys.firstWhere((day) => _isSelected[day]!),
      "endDay": _isSelected.keys.lastWhere((day) => _isSelected[day]!),
      "startTime": openingTime.format(context),
      "endTime": closingTime.format(context),
    };
  }

  void openTimePicker({
    required TimeOfDay selectedTime,
    required void Function(TimeOfDay) onTimeChanged,
  }) {
    showTimePicker(
      context: context,
      initialTime: selectedTime,
    ).then((value) {
      if (value != null) {
        onTimeChanged(value);
      }
    });
  }

  ServiceProvider? workshopDetails;

  void updateWorkShop() {
    setDays();
    workshopDetails = ServiceProvider(
      name: widget.fullName,
      workshopName: widget.workshopName,
      phone: widget.phoneNumber,
      userId: auth.currentUser!.uid,
      latitude: 0,
      longitude: 0,
      image: imagePath ?? "",
      openingdates: structure,
      services: [],
    );
    debugPrint(
        "from workshop_setup_page workshopDetails:${workshopDetails!.toMap()}");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const BackButton(),
        titleTextStyle:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        title: const Text("Let's know more about your shop"),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: ListView(
          controller: ModalScrollController.of(context),
          padding: const EdgeInsets.only(top: 16),
          children: [
            (image == null)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Set a picture of your workshop for easy identification by customers.",
                      style: theme.textTheme.bodySmall?.copyWith(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, bottom: 10),
                    child: Text(
                      "This image has been selected and will be visible to all customers as your workshop's image.",
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Working Hours",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Make your working hours known to your customers.Select all your working days and time.",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: _isSelected.length,
              itemBuilder: (context, index) {
                final day = _isSelected.keys.elementAt(index);
                return Column(
                  children: [
                    CheckboxListTile(
                      value: _isSelected[day]!,
                      onChanged: (value) {
                        setState(() {
                          _isSelected[day] = value!;
                        });
                      },
                      title: Text(day),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WorkshopTimePicker(
                      onTap: () {
                        setState(() {
                          openTimePicker(
                              selectedTime: openingTime,
                              onTimeChanged: (TimeOfDay newTime) {
                                setState(() {
                                  openingTime = newTime;
                                });
                              });
                        });
                      },
                      label: "Opening Time",
                      openingTime: openingTime),
                  WorkshopTimePicker(
                      onTap: () => openTimePicker(
                          selectedTime: closingTime,
                          onTimeChanged: (TimeOfDay newTime) {
                            setState(() {
                              closingTime = newTime;
                            });
                          }),
                      label: "Closing Time",
                      openingTime: closingTime),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton.icon(
                  onPressed: (!isLoading)
                      ? () async {
                          if (image == null) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text("Please select an image"),
                                ),
                              );
                            return;
                          }
                          if (!_isSelected.containsValue(true)) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select at least one working day")),
                              );
                            return;
                          }
                          if (openingTime.hour == closingTime.hour) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Opening and closing time cannot be the same")),
                              );
                            return;
                          }
                          if (image == null) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  content: Text("Please pick an image"),
                                ),
                              );
                            return;
                          }
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await uploadImageToFirebase(image!);
                            updateWorkShop();
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationPage(
                                  serviceProviderDetails: workshopDetails!,
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  content: Text("Something terrible happened"),
                                ),
                              );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      : null,
                  label: isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text("Next"),
                  icon: isLoading
                      ? const SizedBox.shrink()
                      : const Icon(IconlyBold.arrowRight),
                ))
          ],
        ),
      ),
    );
  }
}
