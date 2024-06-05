import 'package:flutter/material.dart';

AppBar bottomSheetAppBar(BuildContext context, String title) {
  final theme = Theme.of(context);
  return AppBar(
    automaticallyImplyLeading: false,
    leading: const CloseButton(),
    titleTextStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    title: Text(title),
  );
}
