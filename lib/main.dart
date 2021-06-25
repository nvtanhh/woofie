import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meowoof/core/ui/toast.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/splash/app/ui/splash_widget.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupInjector();
  setupEasyLoading();
  // set up google_fonts
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('resources/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  // setting status bar color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('vi'),
        Locale(
          'en',
        )
      ],
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
