import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/config/models/onboarding_config.dart';
import '../../common/tools/app_tracking.dart';
import '../../models/app_model.dart';
import 'widgets/version1/onboarding_v1.dart';
import 'widgets/version2/onboarding_v2.dart';
import 'widgets/version3/onboarding_v3.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({
    super.key,
  });

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppTracking.recheck(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Prioritize reading `onBoardingConfig` from config.json over env
    final config = context.select<AppModel, OnBoardingConfig>(
        (model) => model.appConfig?.onBoardingConfig ?? kOnBoardingConfig);

    switch (config.version) {
      case 1:
        return OnBoardingV1(config: config);
      case 3:
        return OnBoardingV3(config: config);
      case 2:
      default:
        return OnBoardingV2(config: config);
    }
  }
}
