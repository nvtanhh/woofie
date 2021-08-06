import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/setting_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';

@lazySingleton
class UpdateSettingUsecase{
  final SettingRepository _settingRepository;
  UpdateSettingUsecase(this._settingRepository);

  Future<Setting> run(int settingId,String setting) async {
    return _settingRepository.updateSetting(settingId,setting);
  }
}