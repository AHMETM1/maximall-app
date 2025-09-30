import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../extensions/extensions.dart';
import '../models/loading_config.dart';

class RiveLoading extends StatelessWidget {
  final LoadingConfig loadingConfig;
  const RiveLoading(this.loadingConfig);

  @override
  Widget build(BuildContext context) {
    final path = loadingConfig.path ?? '';
    if (path.isEmpty) {
      return const SizedBox();
    }

    if (path.isURL) {
      return Center(
        child: RiveAnimation.network(
          path,
        ),
      );
    }
    return Center(
      child: RiveAnimation.asset(
        path,
      ),
    );
  }
}
