import 'dart:convert';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';
import 'package:meowoof/modules/social_network/domain/usecases/setting/create_setting_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/setting/get_setting_remote_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/setting/update_setting_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SettingMessagePageModel extends BaseViewModel {
  final UpdateSettingUsecase _updateSettingUsecase;
  final CreateSettingUsecase _createSettingUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final LoggedInUser _loggedInUser;

  Map<String, dynamic> jsonSetting = {};
  Setting? setting;

  //0 public 1 private
  final RxInt _statusMessage = RxInt(-1);

  SettingMessagePageModel(
    this._updateSettingUsecase,
    this._createSettingUsecase,
    this._getSettingUsecase,
    this._loggedInUser,
  );

  @override
  void initState() {
    getSettingLocal();
    super.initState();
  }

  void getSettingLocal() {
    run(
      () async {
        setting = await _getSettingUsecase.call();
        final loggedInUser = _loggedInUser.user;
        if (loggedInUser!.setting != null) {
          statusMessage = _loggedInUser.user!.setting!.statusMessage();
        } else {
          final Setting? setting = await _getSettingUsecase.call();
          if (setting != null) {
            statusMessage = setting.statusMessage();
          } else {
            statusMessage = 1;
          }
        }
      },
      onSuccess: () {},
    );
  }

  void updateSetting() {
    run(
      () async => setting = await _updateSettingUsecase.run(
        setting!.id,
        jsonEncode(jsonSetting).replaceAll('"', "'"),
      ),
    );
  }

  void createSetting() {
    run(
      () async => setting = await _createSettingUsecase.run(
        jsonEncode(jsonSetting).replaceAll("\"", "'"),
      ),
    );
  }

  void onLangSelected(int? i) {
    statusMessage = i!;
    jsonSetting["message"] = i;
    if (setting != null) {
      updateSetting();
    } else {
      createSetting();
    }
  }

  int get statusMessage => _statusMessage.value;

  set statusMessage(int value) {
    _statusMessage.value = value;
  }
}
