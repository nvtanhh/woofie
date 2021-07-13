import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suga_core/suga_core.dart';

@singleton
class UserStorage extends Storage<User> {
  UserStorage(SharedPreferences prefs) : super(prefs: prefs, key: "current_user");

  @override
  User? get({User? defaultValue}) {
    final String? jsonString = prefs.getString(key);
    return jsonString != null ? User.fromJsonString(jsonString) : defaultValue;
  }

  @override
  void set(User value) {
    prefs.setString(key, value.toJsonString());
  }
}
