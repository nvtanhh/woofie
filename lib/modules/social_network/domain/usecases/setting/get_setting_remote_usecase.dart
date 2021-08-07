import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/setting_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';

@lazySingleton
class GetSettingUsecase {
  final SettingRepository _settingRepository;
  GetSettingUsecase(this._settingRepository);

  Future<Setting> call() async {
    return _settingRepository.getSetting();
  }
}
