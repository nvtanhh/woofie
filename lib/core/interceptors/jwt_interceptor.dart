import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' hide Response;
import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/app/ui/login/login_widget.dart';

@lazySingleton
class JwtInterceptor extends Interceptor {
  final FirebaseAuth auth;

  JwtInterceptor(this.auth);

  @override
  // ignore: missing_return
  Future<void> onConnected(HasuraConnect connect) {}

  @override
  // ignore: missing_return
  Future<void> onDisconnected() {}

  @override
  // ignore: missing_return
  Future onError(HasuraError request) {}

  @override
  Future onRequest(Request request) async {
    final user = auth.currentUser;
    final token = await user.getIdToken();
    if (token != null) {
      try {
        request.headers["Authorization"] = "Bearer $token";
        return request;
      } catch (e) {
        return null;
      }
    } else {
      await Get.offAll(LoginWidget());
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
