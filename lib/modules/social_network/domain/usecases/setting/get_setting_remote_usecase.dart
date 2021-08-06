import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/setting_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';

@lazySingleton
class GetSettingUseacse {
  final SettingRepository _settingRepository;
  GetSettingUseacse(this._settingRepository);

  Future<Setting> call() async {
    return _settingRepository.getSetting();
  }
}
