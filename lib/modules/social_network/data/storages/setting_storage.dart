import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suga_core/suga_core.dart';

@singleton
class SettingStorage extends Storage<Setting> {
  SettingStorage(SharedPreferences prefs)
      : super(prefs: prefs, key: "current_setting") {
    get();
  }

  Setting? setting;

  @override
  Setting? get({Setting? defaultValue}) {
    final String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      // ignore: join_return_with_assignment
      setting = Setting.fromJsonString(jsonString);
      return setting;
    } else {
      return defaultValue;
    }
  }

  @override
  void set(Setting value) {
    setting = value;
    prefs.setString(key, value.toJsonString());
  }
}
