import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/setting_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';

@lazySingleton
class SettingRepository {
  final SettingDatasource _settingDatasource;

  SettingRepository(this._settingDatasource);

  Future<Setting> getSetting() {
    return _settingDatasource.getSetting();
  }

  Future<Setting> updateSetting(int settingId, String setting) {
    return _settingDatasource.updateSetting(settingId, setting);
  }

  Future<Setting?> getSettingLocal() {
    return _settingDatasource.getSettingLocal();
  }

  Future<Setting> createSetting(String setting) {
    return _settingDatasource.createSetting(setting);
  }
}
