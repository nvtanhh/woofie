import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meowoof/configs/app_config.dart';
import 'package:meowoof/configs/backend_config.dart';
import 'package:meowoof/core/interceptors/jwt_interceptor.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suga_core/suga_core.dart';

import 'injector.config.dart';

final injector = GetIt.instance;

@injectableInit
void setupInjector() => $initGetIt(injector, environment: Environment.dev);

@module
abstract class RegisterModule {
  @lazySingleton
  @preResolve
  Future<FirebaseApp> getFirebaseApp() async => Firebase.initializeApp();

  @lazySingleton
  @preResolve
  Future<SharedPreferences> getSharePreferences() async => SharedPreferences.getInstance();

  @lazySingleton
  Logger getLogger() => Logger(
        level: AppConfig.LOG_LEVEL,
      );

  @lazySingleton
  EventBus getEventBus() => EventBus();

  @lazySingleton
  FirebaseAuth getFirebaseAuth() => FirebaseAuth.instance;

  @lazySingleton
  GoogleSignIn getGoogleSignIn() => GoogleSignIn();

  @lazySingleton
  FacebookAuth getFacebookAuth() => FacebookAuth.instance;

  @lazySingleton
  HasuraConnect getHasuraConnect(JwtInterceptor interceptor) {
    return HasuraConnect(BackendConfig.BASE_HASURA_URL, interceptors: [interceptor]);
  }

  @lazySingleton
  @Named('current_user_storage')
  UserStorage getCurrentUserStorage(SharedPreferences prefs) => UserStorage(prefs, 'current_user');
}
