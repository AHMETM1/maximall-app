import 'package:injectable/injectable.dart';

import 'di.config.dart';
import 'di_core.dart';

@InjectableInit(
  initializerName: 'init', // default
  // preferRelativeImports: true, // default
  asExtension: false, // default
  externalPackageModulesBefore: [],
  externalPackageModulesAfter: [],
)
Future<void> configureDependencies({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async =>
    init(
      injector,
      environment: environment,
      environmentFilter: environmentFilter,
    );
