import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';
import 'package:meowoof/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SettingModel extends BaseViewModel {
  final LogoutUsecase _logoutUsecase;

  SettingModel(this._logoutUsecase);

  void logOut() {
    call(
      () async => _logoutUsecase.call(),
      onSuccess: () {
        Get.offAll(() => WelcomeWidget());
      },
    );
  }

  void language() {}

  void notification() {}
}
