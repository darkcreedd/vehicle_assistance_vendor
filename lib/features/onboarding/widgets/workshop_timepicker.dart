import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkshopTimePicker extends StatelessWidget {
  const WorkshopTimePicker(
      {super.key,
      required this.openingTime,
      required this.label,
      required this.onTap});

  final TimeOfDay openingTime;
  final Function() onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        ActionChip(
            onPressed: onTap,
            side: const BorderSide(color: Colors.black),
            label: Text(
              DateFormat.jm().format(
                  DateTime(2022, 1, 1, openingTime.hour, openingTime.minute)),
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
