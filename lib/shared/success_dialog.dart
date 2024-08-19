import 'package:flutter/material.dart';

Future showSuccessDialog(
  BuildContext context,
) {
  final theme = Theme.of(context);

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: Icon(
                    Icons.check_circle,
                    size: 100,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "Success",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"))
            ],
          ));
}
