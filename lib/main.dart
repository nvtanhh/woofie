import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:meowoof/injector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjector();
  setupEasyLoading();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'resources/langs',
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => OrientationBuilder(
        builder: (context, orientation) {
          // SizerUtil().init(constraints, orientation);
          return ScreenUtilInit(
            designSize: const Size(1366, 844),
            builder: () => GetMaterialApp(
              title: 'MeoWoof',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: (BuildContext context, Widget child) {
                return FlutterEasyLoading(child: child);
              },
              home: Container(),
            ),
          );
        },
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
