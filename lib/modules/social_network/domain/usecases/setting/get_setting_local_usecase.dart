import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/setting_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';

@lazySingleton
class GetSettingLocalUseacse {
  final SettingRepository _settingRepository;
  GetSettingLocalUseacse(this._settingRepository);

  Future<Setting?> run() async {
    return _settingRepository.getSettingLocal();
  }
}
