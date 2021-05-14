import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suga_core/suga_core.dart';

class UserStorage extends Storage<User> {
  UserStorage(SharedPreferences prefs, String key) : super(prefs: prefs, key: key);

  @override
  User get({User defaultValue}) {
    final String jsonString = prefs.getString(key);
    return jsonString != null ? User.fromJsonString(jsonString) : defaultValue;
  }

  @override
  void set(User value) {
    prefs.setString(key, value.toJsonString());
  }
}
