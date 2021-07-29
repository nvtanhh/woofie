import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

@lazySingleton
class GetDetailInfoPetUsecase {
  final ProfileRepository _profileRepository;

  GetDetailInfoPetUsecase(this._profileRepository);
  Future<Map<String, dynamic>> call(int idPet) async {
    return _profileRepository.getDetailInfoPet(idPet);
  }
}
