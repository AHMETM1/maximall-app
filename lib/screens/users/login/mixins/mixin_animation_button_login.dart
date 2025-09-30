import 'package:flutter/material.dart';

import '../../../../common/constants.dart';

enum AnimationButtonLoginType {
  usernamePassword,
  email,
  ;

  bool get isUsernamePassword =>
      this == AnimationButtonLoginType.usernamePassword;

  bool get isEmail => this == AnimationButtonLoginType.email;
}

/// [AnimationButtonLoginMixin] is a mixin that supports using animation for
/// buttons on the login screen.
///
/// To use [AnimationButtonLoginMixin], the screen needs to use
/// [AnimationButtonLoginMixin] and [TickerProviderStateMixin] at the same time.
///
/// {@tool snippet}
/// Example:
///
/// ```dart
/// class LoginExampleScreen extends StatefulWidget {
///   const LoginExampleScreen({super.key});
///   @override
///   State<LoginExampleScreen> createState() => _LoginExampleScreenState();
/// }
///
/// class _LoginExampleScreenState extends State<LoginExampleScreen>
///     with TickerProviderStateMixin, AnimationButtonLoginMixin {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Column(children: [
///         StaggerAnimation(
///           titleButton: 'Login',
///           buttonController: loginButtonController.view as AnimationController,
///           onTap: () {},
///         ),
///       ]),
///     );
///   }
/// }
/// ```
/// {@end-tool}
mixin AnimationButtonLoginMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _loginButtonController;
  late AnimationController _loginEmailButtonController;
  AnimationController get loginButtonController => _loginButtonController;

  AnimationController get loginEmailButtonController =>
      _loginEmailButtonController;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  Future playAnimation(
      [AnimationButtonLoginType type =
          AnimationButtonLoginType.usernamePassword]) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (type.isEmail) {
        await _loginEmailButtonController.forward();
        return;
      }
      await _loginButtonController.forward();
    } on TickerCanceled {
      printLog('[_playAnimation] error');
    }
  }

  Future stopAnimation(
      [AnimationButtonLoginType type =
          AnimationButtonLoginType.usernamePassword]) async {
    try {
      if (type.isEmail) {
        await _loginEmailButtonController.reverse();
      } else {
        await _loginButtonController.reverse();
      }
      setState(() {
        _isLoading = false;
      });
    } on TickerCanceled {
      printLog('[_stopAnimation] error');
    }
  }

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    _loginEmailButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() async {
    _loginButtonController.dispose();
    _loginEmailButtonController.dispose();
    super.dispose();
  }
}
