import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerListenerWidget<T> extends StatelessWidget {
  const ConsumerListenerWidget({
    super.key,
    required this.builder,
    this.listener,
  });

  final Widget Function(
    BuildContext context,
    T value,
    Widget? child,
  ) builder;

  final void Function(BuildContext context, T value)? listener;

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, value, child) {
        if (listener != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            listener!(context, value);
          });
        }

        return builder(context, value, child);
      },
    );
  }
}
