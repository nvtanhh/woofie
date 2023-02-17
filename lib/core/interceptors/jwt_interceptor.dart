import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' hide Response;
import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';

@lazySingleton
class JwtInterceptor extends Interceptor {
  final FirebaseAuth auth;
  String? jwtToken;

  JwtInterceptor(this.auth) {
    HttpOverrides.global = MyHttpOverrides();
  }

  @override
  Future onError(HasuraError request) async {
    jwtToken = await auth.currentUser?.getIdToken(true);
    printError(info: request.message);
  }

  @override
  Future onResponse(Response data) async {
    return data;
  }

  @override
  Future<void>? onConnected(HasuraConnect connect) {}

  @override
  Future<void>? onDisconnected() {}

  @override
  Future? onRequest(Request request) async {
    jwtToken = null;
    jwtToken = await auth.currentUser!.getIdToken();
    if (jwtToken != null) {
      request.headers["Authorization"] = "Bearer $jwtToken";
      return request;
    } else {
      await Get.offAll(WelcomeWidget());
    }
  }

  @override
  Future<void>? onSubscription(Request request, Snapshot snapshot) {}

  @override
  Future<void>? onTryAgain(HasuraConnect connect) {}
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        final isValidHost =
            ["103.195.238.188"].contains(host); // <-- allow only hosts in array
        return isValidHost;
      });
  }
}
