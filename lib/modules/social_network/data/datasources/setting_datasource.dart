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

  SettingDatasource(this._hasuraConnect, this._loggedInUser, this._settingStorage);

  Future<Setting> getSetting() async {
    String query = """
    query MyQuery {
  settings(where: {owner_uuid: {_eq: "${_loggedInUser.user!.uuid}"}}) {
    created_at
    id
    owner_uuid
    setting
    updated_at
  }
}
    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["settings"] as List;
    return Setting.fromJson(listPost[0] as Map<String, dynamic>);
  }

  Future<Setting> updateSetting(int settingId, String setting) async {
    String mutation = """
    mutation MyMutation {
      update_settings_by_pk(pk_columns: {id: $settingId}, _set: {setting: "$setting"}) {
        created_at
        id
        owner_uuid
        setting
        updated_at
        setting
      }
    }
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final map = GetMapFromHasura.getMap(data as Map)["update_settings_by_pk"] as Map<String, dynamic>;
    final newSetting = Setting.fromJson(map);
    _settingStorage.set(newSetting);
    return newSetting;
  }

  Future<Setting?> getSettingLocal() async {
    return _settingStorage.setting;
  }

  Future<Setting> createSetting(String setting) async{
    String mutation = """
mutation MyMutation {
  insert_settings_one(object: {setting: "$setting"}) {
    updated_at
    setting
    owner_uuid
    id
  }
}
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final listPost = GetMapFromHasura.getMap(data as Map)["insert_settings_one"] as Map<String, dynamic>;
    final newSetting = Setting.fromJson(listPost);
    _settingStorage.set(newSetting);
    return newSetting;
  }
}
