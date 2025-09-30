import 'package:flutter/material.dart';

import '../dependency_injection/di_core.dart';

abstract class AppCoordinatorShared<T> {
  Future<T?> showOpenAiKey([String? identifier]) async => null;
}

class AppCoordinatorSharedImpl<T> extends AppCoordinatorShared<T> {
  final BuildContext context;
  AppCoordinatorSharedImpl(this.context);
}

extension AppCoordinator<T> on BuildContext {
  AppCoordinatorShared<T> get shared => injector.get(param1: this);

  Future<T?> showOpenAiKey([String? identifier]) => shared.showOpenAiKey();
}
