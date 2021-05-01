import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';

@lazySingleton
class JwtInterceptor extends Interceptor {
  final FirebaseAuth auth;
  String jwtToken;
  User user;

  JwtInterceptor(this.auth);

  @override
  // ignore: missing_return
  Future<void> onConnected(HasuraConnect connect) {}

  @override
  // ignore: missing_return
  Future<void> onDisconnected() {}

  @override
  Future onError(HasuraError request) async {
    await Fluttertoast.showToast(
      msg: request.message,
    );
  }

  @override
  Future onRequest(Request request) async {
    user = auth.currentUser;
    jwtToken = await user.getIdToken();
    if (jwtToken != null) {
      try {
        request.headers["Authorization"] = "Bearer $jwtToken";
        return request;
      } catch (e) {
        return null;
      }
    } else {
      await Get.offAll(WelcomeWidget());
    }
  }

  @override
  Future onResponse(Response data) async {
    return data;
  }

  @override
  // ignore: missing_return
  Future<void> onSubscription(Request request, Snapshot snapshot) {}

  @override
  // ignore: missing_return
  Future<void> onTryAgain(HasuraConnect connect) {}
}
