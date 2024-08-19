import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.label,
    required this.value,
  });
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              label,
            ),
            Text(
              '$value',
              style: Theme.of(context).textTheme.displayMedium,
            )
          ],
        ),
      ),
    );
  }
}

class RequestTally {
  final String label;
  final int value;
  RequestTally({
    required this.label,
    required this.value,
  });
}
