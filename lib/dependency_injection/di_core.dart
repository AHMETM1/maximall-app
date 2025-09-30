import 'package:get_it/get_it.dart';

GetIt injector = GetIt.instance;

/// Check if the instance is registered. If it is not registered,
/// it will be registerFactory using the registerInstant method.
void tryRegisterFactory<T extends Object>(T Function() registerInstance) =>
    _checkRegister(registerInstance, type: _RegisterType.factoryRegister);

/// Check if the instance is registered. If it is not registered,
/// it will be registerSingleton using the registerInstant method.
void tryRegisterSingleton<T extends Object>(T Function() registerInstance) =>
    _checkRegister(registerInstance, type: _RegisterType.singletonRegister);

/// Check if the instance is registered. If it is not registered,
/// it will be registerLazySingleton using the registerInstant method.
void tryRegisterLazySingleton<T extends Object>(
        T Function() registerInstance) =>
    _checkRegister(registerInstance, type: _RegisterType.lazySingletonRegister);

/// ------- handle logic check isRegistered and register --------
void _checkRegister<T extends Object>(T Function() registerInstance,
    {required _RegisterType type}) {
  final isRegisted = injector.isRegistered<T>();
  if (isRegisted == false) {
    type.register(registerInstance);
  }
}

enum _RegisterType {
  singletonRegister,
  factoryRegister,
  lazySingletonRegister,
  ;

  void register<T extends Object>(T Function() registerInstance) {
    switch (this) {
      case singletonRegister:
        injector.registerSingleton(registerInstance());
        break;
      case factoryRegister:
        injector.registerFactory(() => registerInstance());
        break;
      case lazySingletonRegister:
        injector.registerLazySingleton(() => registerInstance());
        break;
    }
  }
}
