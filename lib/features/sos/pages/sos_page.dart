import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '/shared/data/emergency.dart';

import '../../../shared/widgets/bottom_sheet_appbar.dart';

class SOSPage extends StatelessWidget {
  const SOSPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: bottomSheetAppBar(context, "Emergency"),
      body: ListView(
        controller: ModalScrollController.of(context),
        padding: const EdgeInsets.all(16),
        children: [
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Before Help Arrives",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "1. "),
                        TextSpan(
                          text: "Find a safe spot: ",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                            text:
                                "Pull over as far as you can from traffic. If you can't stop, turn on your hazard lights"),
                      ],
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "2. "),
                        TextSpan(
                          text: "Stay visible: ",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                            text:
                                "Use hazard lights or reflective items if it's dark. Place them behind your car, at least 100 feet away."),
                      ],
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "3. "),
                        TextSpan(
                          text: "Stay in your car (if safe): ",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                            text:
                                "If there's a risk of fire or other immediate danger, exit the vehicle and move to a safe location away from traffic. "),
                      ],
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text("Select Emergency",
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: emergencies.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final emergency = emergencies[index];
              return Card.outlined(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const ServiceProviders()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.asset(emergency.image, width: 60),
                        const Spacer(),
                        Text(
                          emergency.name,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
