import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

@lazySingleton
class GetDetailInfoPetUsecase {
  Future<Pet> call(int idPet) async {
    await Future.delayed(const Duration(seconds: 1));
    return Pet(name: "Vàng", avatar: "http://thucanhviet.com/wp-content/uploads/2018/03/Pom-2-thang-mat-cuc-xinh-696x528.jpg");
  }
}
