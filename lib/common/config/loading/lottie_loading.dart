import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../extensions/extensions.dart';
import '../models/loading_config.dart';

class LottieLoading extends StatelessWidget {
  final LoadingConfig loadingConfig;
  const LottieLoading(this.loadingConfig);

  @override
  Widget build(BuildContext context) {
    final path = loadingConfig.path ?? '';
    if (path.isEmpty) {
      return const SizedBox();
    }

    if (path.isURL) {
      return Center(
        child: Lottie.network(
          path,
          errorBuilder: (_, __, ___) {
            return const SizedBox();
          },
        ),
      );
    }
    return Center(
      child: Lottie.asset(
        path,
        errorBuilder: (_, __, ___) {
          return const SizedBox();
        },
      ),
    );
  }
}
