import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meowoof/configs/app_config.dart';
import 'package:meowoof/core/interceptors/jwt_interceptor.dart';
import 'package:meowoof/core/services/environment_service.dart';
import 'package:meowoof/injector.config.dart';
import 'package:shared_preferences/shared_preferences.dart';

final injector = GetIt.instance;

@injectableInit
Future setupInjector() async => injector.init(environment: Environment.dev);

@module
abstract class RegisterModule {
  @lazySingleton
  @preResolve
  Future<FirebaseApp> getFirebaseApp() => Firebase.initializeApp();

  @lazySingleton
  @preResolve
  Future<SharedPreferences> getSharePreferences() =>
      SharedPreferences.getInstance();

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
    return HasuraConnect(
      injector<EnvironmentService>().hasuraUrl,
      interceptors: [interceptor],
    );
  }

  @lazySingleton
  FlutterLocalNotificationsPlugin getFlutterLocalNotificationsPlugin() {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_onesignal_default');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    return flutterLocalNotificationsPlugin;
  }
}
