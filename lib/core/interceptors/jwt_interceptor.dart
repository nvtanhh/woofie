import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';

@lazySingleton
class JwtInterceptor extends Interceptor {
  final FirebaseAuth auth;

  JwtInterceptor(this.auth);

  @override
  Future onError(HasuraError request) async {
    await Fluttertoast.showToast(
      msg: request.message,
    );
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
    final jwtToken = await auth.currentUser?.getIdToken();
    if (jwtToken != null) {
      try {
        request.headers["Authorization"] = "Bearer $jwtToken";
        // printInfo(info: jwtToken.substring(0, (jwtToken.length / 2).floor() + 3));
        // printInfo(info: jwtToken.substring((jwtToken.length / 2).floor(), jwtToken.length));
        return request;
      } catch (e) {
        await Get.offAll(WelcomeWidget());
      }
    } else {
      await Get.offAll(WelcomeWidget());
    }
  }

  @override
  Future<void>? onSubscription(Request request, Snapshot snapshot) {}

  @override
  Future<void>? onTryAgain(HasuraConnect connect) {}
}
