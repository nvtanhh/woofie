import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meowoof/configs/app_config.dart';
import 'package:meowoof/core/ui/toast.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/app/pages/chat_dashboard.dart';
import 'package:meowoof/modules/chat/app/request_message/request_message.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_detail_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/splash/app/ui/splash_widget.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupInjector();
  setupEasyLoading();
  setupOneSignal();
  // set up google_fonts
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('resources/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  // setting status bar color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('vi'), Locale('en')],
      path: 'resources/langs',
      fallbackLocale: const Locale('vi'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () => MFToast(
        child: GetMaterialApp(
          title: 'MeoWoof',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            textTheme: GoogleFonts.montserratTextTheme(),
            appBarTheme: AppBarTheme(
              textTheme: GoogleFonts.montserratTextTheme(),
              backgroundColor: UIColor.white,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: UIColor.textHeader,
              ),
            ),
            accentColor: UIColor.primary,
            primaryColor: UIColor.primary,
            scaffoldBackgroundColor: UIColor.white,
            sliderTheme: SliderThemeData(
              valueIndicatorColor: UIColor.primary,
              valueIndicatorTextStyle: UITextStyle.primary_14_w600,
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return FlutterEasyLoading(child: child);
          },
          home: SplashWidget(),
          color: UIColor.white,
        ),
      ),
    );
  }
}

void setupOneSignal() {
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId(AppConfig.APP_ID_ONESIGNAL);
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
    (OSNotificationReceivedEvent notification) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      notification.complete(notification.notification);
    },
  );
  OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    try {
      int? postId =
          openedResult.notification.additionalData?["post_id"] as int?;
      int? postType =
          openedResult.notification.additionalData?["post_type"] as int?;
      if (postId != null) {
        if (postType != null) {
          if (postType == 3) {
            Get.to(() => AdoptionPetDetailWidget(
                post: Post(id: postId, type: PostType.lose, uuid: "")));
          } else {
            Get.to(() => const ChatDashboard());
          }
        } else {
          Get.to(() => PostDetail(
              post: Post(id: postId, type: PostType.activity, uuid: "")));
        }
      } else {
        Get.to(() => RequestMessagePage());
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  });
  OneSignal.shared.consentGranted(true);
}

void setupEasyLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.blue
    ..progressColor = Colors.blue
    ..userInteractions = false
    ..textColor = Colors.black;
}
