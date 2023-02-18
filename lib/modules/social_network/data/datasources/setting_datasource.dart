import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/modules/social_network/data/storages/setting_storage.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';

@lazySingleton
class SettingDatasource {
  final HasuraConnect _hasuraConnect;
  final LoggedInUser _loggedInUser;
  final SettingStorage _settingStorage;

  SettingDatasource(
      this._hasuraConnect, this._loggedInUser, this._settingStorage,);

  Future<Setting?> getSetting() async {
    try {
      final String query = """
      query MyQuery {
        users_by_pk(id: "${_loggedInUser.user!.id}") {
          setting {
            id
            setting
            created_at
            updated_at
          }
        }
      }
      """;
      final data = await _hasuraConnect.query(query);
      final json = GetMapFromHasura.getMap(data as Map)["users_by_pk"]
          ['setting'] as Map<String, dynamic>;
      return Setting.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<Setting> updateSetting(int settingId, String setting) async {
    final String mutation = """
    mutation MyMutation {
      update_settings_by_pk(pk_columns: {id: $settingId}, _set: {setting: "$setting"}) {
        created_at
        id
        setting
        updated_at
        setting
      }
    }
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final map = GetMapFromHasura.getMap(data as Map)["update_settings_by_pk"]
        as Map<String, dynamic>;
    final newSetting = Setting.fromJson(map);
    _settingStorage.set(newSetting);
    return newSetting;
  }

  Future<Setting?> getSettingLocal() async {
    return _settingStorage.setting;
  }

  Future<Setting> createSetting(String setting) async {
    final String createSetting = """
    mutation MyMutation {
      insert_settings_one(object: {setting: "$setting"}) {
        id
        setting
        updated_at
      }
    }
    """;
    final data = await _hasuraConnect.mutation(createSetting);
    final json = GetMapFromHasura.getMap(data as Map)["insert_settings_one"]
        as Map<String, dynamic>;
    final newSetting = Setting.fromJson(json);
    final String updateSettingId = """
    mutation MyMutation {
      update_users_by_pk(pk_columns: {id: "${_loggedInUser.user!.id}"}, _set: {setting_id: ${newSetting.id}}) {
        id
      }
    }
    """;
    await _hasuraConnect.mutation(updateSettingId);

    _settingStorage.set(newSetting);
    return newSetting;
  }
}
