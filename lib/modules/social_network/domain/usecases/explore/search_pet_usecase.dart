import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

@lazySingleton
class SearchPetUsecase {
  Future<List<Pet>> call(String keyWord, {int offset = 0}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (keyWord.isEmpty)
      return const <Pet>[];
    else {
      return <Pet>[
        Pet(name: "Vàng", avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg"),
        Pet(name: "Đỏ", avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg"),
      ];
    }
  }
}
