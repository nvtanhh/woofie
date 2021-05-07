import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';

@lazySingleton
class HasuraDatasource {
  final HasuraConnect _hasuraConnect;

  HasuraDatasource(this._hasuraConnect);

  Future<bool> checkUseHavePet() async {
    final queryCountPetFromUser = """
    query countPet {
    pets_aggregate {
    aggregate {
      count(columns: id)
    }
    }
    }
    """;
    final data = await _hasuraConnect.query(queryCountPetFromUser);
    final listUser = GetMapFromHasura.getMap(data as Map)["pets_aggregate"] as Map;
    if ((listUser["aggregate"]["count"] as int) > 0) {
      return true;
    } else {
      return false;
    }
  }
}
