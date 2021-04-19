// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:event_bus/event_bus.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i4;
import 'package:shared_preferences/shared_preferences.dart' as _i5;
import 'package:suga_core/suga_core.dart' as _i6;

import 'injector.dart' as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get, {String environment, _i2.EnvironmentFilter environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i3.EventBus>(() => registerModule.getEventBus());
  gh.lazySingleton<_i4.Logger>(() => registerModule.getLogger());
  await gh.lazySingletonAsync<_i5.SharedPreferences>(() => registerModule.getSharePreferences(), preResolve: true);
  gh.lazySingleton<_i6.Oauth2Manager>(() => registerModule.getOauth2Manager(get<_i5.SharedPreferences>(), get<_i4.Logger>()));
  gh.lazySingleton<_i6.HttpClientWrapper>(() => registerModule.getHttpClient(get<_i6.Oauth2Manager>(), get<_i4.Logger>()));
  return get;
}

class _$RegisterModule extends _i7.RegisterModule {}
