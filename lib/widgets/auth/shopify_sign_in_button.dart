import 'package:flutter/material.dart';

class SignInButtonShopify extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;

  const SignInButtonShopify({
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Sign in with OTP'),
    );
  }
}
