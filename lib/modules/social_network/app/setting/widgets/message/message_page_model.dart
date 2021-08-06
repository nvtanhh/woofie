import 'dart:convert';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';
import 'package:meowoof/modules/social_network/domain/usecases/setting/create_setting_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/setting/get_setting_local_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/setting/update_setting_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class MessagePageModel extends BaseViewModel {
  final UpdateSettingUsecase _updateSettingUsecase;
  final GetSettingLocalUseacse _getSettingLocalUseacse;
  final CreateSettingUsecase _createSettingUsecase;
  Map<String, dynamic> jsonSetting = {};
  Setting? settings;

  //0 public 1 private
  final RxInt _statusMessage = RxInt(1);

  MessagePageModel(
    this._updateSettingUsecase,
    this._getSettingLocalUseacse,
    this._createSettingUsecase,
  );

  @override
  void initState() {
    getSettingLocal();
    super.initState();
  }

  void getSettingLocal() {
    call(
      () async => settings = await _getSettingLocalUseacse.run(),
      onSuccess: () {
        if (settings == null) {
          statusMessage = 1;
        } else {
          jsonSetting = jsonDecode(settings!.setting!.replaceAll("'", "\"")) as Map<String, dynamic>;
          statusMessage = (jsonSetting["message"] as int?) ?? 1;
        }
      },
    );
  }

  void updateSetting() {
    call(
      () async => settings = await _updateSettingUsecase.run(
        settings!.id,
        jsonEncode(jsonSetting).replaceAll("\"", "'"),
      ),
    );
  }

  void createSetting() {
    call(
      () async => settings = await _createSettingUsecase.run(
        jsonEncode(jsonSetting).replaceAll("\"", "'"),
      ),
    );
  }

  void onLangSelected(int? i) {
    statusMessage = i!;
    jsonSetting["message"] = i;
    if (settings != null) {
      updateSetting();
    } else {
      createSetting();
    }
  }

  int get statusMessage => _statusMessage.value;

  set statusMessage(int value) {
    _statusMessage.value = value;
  }

  @override
  void disposeState() {
    super.disposeState();
  }
}
