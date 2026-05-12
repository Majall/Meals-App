import 'package:flutter/material.dart';
import 'package:meals_app/theme/app_theme.dart';

void showAppToast(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle,
  Color? backgroundColor,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final snackbar = SnackBar(
    content: Row(
      children: [
        Icon(icon, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(message)),
      ],
    ),
    backgroundColor: backgroundColor ?? colorScheme.surface,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(AppSpacing.lg),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(snackbar);
}
