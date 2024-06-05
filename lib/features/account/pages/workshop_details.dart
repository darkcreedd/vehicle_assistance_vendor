import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/features/account/pages/reviews_page.dart';
import '/features/services/add_services_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyWorkShopPage extends StatefulWidget {
  const MyWorkShopPage({super.key});

  @override
  State<MyWorkShopPage> createState() => _MyWorkShopPageState();
}

class _MyWorkShopPageState extends State<MyWorkShopPage> {
  final Map<String, bool> _isSelected = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  final Map<String, TimeOfDay> _openingTimes = {
    'Monday': const TimeOfDay(hour: 0, minute: 0),
    'Tuesday': const TimeOfDay(hour: 0, minute: 0),
    'Wednesday': const TimeOfDay(hour: 0, minute: 0),
    'Thursday': const TimeOfDay(hour: 0, minute: 0),
    'Friday': const TimeOfDay(hour: 0, minute: 0),
    'Saturday': const TimeOfDay(hour: 0, minute: 0),
    'Sunday': const TimeOfDay(hour: 0, minute: 0),
  };

  final Map<String, TimeOfDay> _closingTimes = {
    'Monday': const TimeOfDay(hour: 0, minute: 0),
    'Tuesday': const TimeOfDay(hour: 0, minute: 0),
    'Wednesday': const TimeOfDay(hour: 0, minute: 0),
    'Thursday': const TimeOfDay(hour: 0, minute: 0),
    'Friday': const TimeOfDay(hour: 0, minute: 0),
    'Saturday': const TimeOfDay(hour: 0, minute: 0),
    'Sunday': const TimeOfDay(hour: 0, minute: 0),
  };

  void _selectTime(String day, bool isOpening) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpening ? _openingTimes[day]! : _closingTimes[day]!,
    );

    if (picked != null) {
      final int hour = picked.hourOfPeriod;
      final String period = picked.period.name;
      final TimeOfDay formattedTime =
          TimeOfDay(hour: hour, minute: picked.minute);
      setState(() {
        if (isOpening) {
          _openingTimes[day] = formattedTime;
        } else {
          _closingTimes[day] = formattedTime;
        }
      });
      final String formattedHour = DateFormat.jm()
          .format(DateTime(2022, 1, 1, picked.hour, picked.minute));
      print('Selected time: $formattedHour');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              imageUrl:
                  "https://images.pexels.com/photos/190537/pexels-photo-190537.jpeg?auto=compress&cs=tinysrgb&w=800",
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "KNUST Mechanic Shop",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Text("Kumasi - Tech Junction"),
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
                              builder: (context) {
                                return const AddServicesPage();
                              },
                            );
                          },
                          child: const Text("Edit Services"))
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Working Hours",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
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
                      if (_isSelected[day]!)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _selectTime(day, true);
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Opens At"),
                                    Container(
                                      width: 80,
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: Text(
                                          '${_openingTimes[day]!.hour}:${_openingTimes[day]!.minute.toString().padLeft(2, '0')} ${_openingTimes[day]!.period.name.toUpperCase()}'),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _selectTime(day, false);
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Closes At"),
                                        Container(
                                          width: 80,
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          child: Text(
                                              '${_closingTimes[day]!.hour}:${_closingTimes[day]!.minute.toString().padLeft(2, '0')} ${_closingTimes[day]!.period.name.toUpperCase()}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ],
                          ),
                        )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Opening Times: $_openingTimes");
          print("Closing Times: $_closingTimes");
          print("Available Days: $_isSelected");
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
