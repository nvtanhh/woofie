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
  Oauth2Manager getOauth2Manager(SharedPreferences prefs, Logger logger) {
    final Oauth2Manager config = Oauth2Manager(
      endpoint: Uri.parse("${BackendConfig.BASE_URL}/oauth/token"),
      credentialStorage: OAuth2CredentialsStorage(prefs: prefs),
      secret: BackendConfig.OAUTH2_CLIENT_SECRET,
      identifier: BackendConfig.OAUTH2_CLIENT_ID,
      logger: logger,
    );
    return config;
  }

  @lazySingleton
  HttpClientWrapper getHttpClient(Oauth2Manager oauth2Manager, Logger logger) {
    final HttpClientWrapper wrapper = HttpClientWrapper(
      options: BaseOptions(
        baseUrl: BackendConfig.BASE_URL,
        connectTimeout: BackendConfig.CONNECT_TIMEOUT,
        receiveTimeout: BackendConfig.RECEIVE_TIMEOUT,
      ),
      logger: logger,
      oauth2Manager: oauth2Manager,
      verbose: AppConfig.LOG_LEVEL == Level.verbose,
    );
    return wrapper;
  }

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
}
