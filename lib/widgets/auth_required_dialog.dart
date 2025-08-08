import 'package:flutter/material.dart';

class AuthRequiredDialog extends StatelessWidget {
  final VoidCallback onLoginTap;
  final VoidCallback? onCancelTap;

  const AuthRequiredDialog({
    super.key,
    required this.onLoginTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Authentication Required'),
      content: const Text('You need to sign in to use this feature.'),
      actions: [
        TextButton(
          onPressed: onCancelTap ?? () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: onLoginTap, child: const Text('Sign In')),
      ],
    );
  }
}
