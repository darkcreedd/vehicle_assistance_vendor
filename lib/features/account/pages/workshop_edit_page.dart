import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vehicle_assistance_vendor/features/root_app_page.dart';
import 'package:vehicle_assistance_vendor/shared/entities/service_provider.dart';

import '../../../shared/providers/account_provider.dart';
import '../../../shared/success_dialog.dart';
import '../../onboarding/widgets/workshop_timepicker.dart';

class WorkShopEditPage extends ConsumerStatefulWidget {
  const WorkShopEditPage({
    super.key,
  });

  @override
  WorkShopSetupPageState createState() => WorkShopSetupPageState();

  // @override
  // State<WorkShopEditPage> createState() => WorkShopSetupPageState();
}

class WorkShopSetupPageState extends ConsumerState<WorkShopEditPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool isLoading = false;

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

  Map<String, String>? structure = {
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

  @override
  Widget build(BuildContext context) {
    final account = ref.read(accountProvider.notifier);
    final user = ref.watch(accountProvider);

    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CloseButton(),
        titleTextStyle:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        title: const Text("Let's keep your shop details up to date"),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: ListView(
          controller: ModalScrollController.of(context),
          padding: const EdgeInsets.only(top: 16),
          children: [
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
                    "Edit your working hours to keep your customers updated on your working hours.",
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

                          try {
                            setState(() {
                              isLoading = true;
                            });
                            setDays();
                            await account.updateProfile(ServiceProvider(
                                name: user.value!.name,
                                services: user.value!.services,
                                image: user.value!.image,
                                userId: user.value!.userId,
                                longitude: user.value!.longitude,
                                latitude: user.value!.latitude,
                                phone: user.value!.phone,
                                openingdates:
                                    structure ?? user.value!.openingdates,
                                workshopName: user.value!.workshopName));
                            if (!context.mounted) return;
                            showSuccessDialog(context)
                                .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RootAppPage()),
                                    ));
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  content: Text(
                                      "Something terrible happened, try again later."),
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
