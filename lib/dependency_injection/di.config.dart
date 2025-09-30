// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flux_interface/flux_interface.dart' as _i3;
import 'package:fstore/common/config/models/dynamic_link/dynamic_link.dart'
    as _i5;
import 'package:fstore/dependency_injection/modules/firebase_module.dart'
    as _i6;
import 'package:fstore/services/link_service.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final firebaseModule = _$FirebaseModule();
  gh.factory<_i3.FirebaseNotificationService>(
      () => firebaseModule.firebaseNotificationService());
  gh.factory<_i3.LoyaltyFirestoreService>(
      () => firebaseModule.loyaltyFirestoreService());
  gh.singleton<_i3.FirebaseCoreService>(
      () => firebaseModule.firebaseCoreService());
  gh.singleton<_i3.BaseFirebaseServices>(
      () => firebaseModule.baseFirebaseServices());
  gh.singleton<_i3.FirebaseMessagingService>(
      () => firebaseModule.firebaseMessagingService());
  gh.factoryParam<_i3.FirebaseDynamicLinkService, _i4.LinkService,
      _i5.FirebaseDynamicLinkServiceConfig>((
    linkService,
    config,
  ) =>
      firebaseModule.firebaseDynamicLinkService(
        linkService,
        config,
      ));
  return getIt;
}

class _$FirebaseModule extends _i6.FirebaseModule {}
