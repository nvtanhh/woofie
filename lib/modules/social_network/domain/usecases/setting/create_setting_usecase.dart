import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/setting_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';

@lazySingleton
class CreateSettingUsecase{
  final SettingRepository _settingRepository;
  CreateSettingUsecase(this._settingRepository);

  Future<Setting> run(String setting) async {
    return _settingRepository.createSetting(setting);
  }
}