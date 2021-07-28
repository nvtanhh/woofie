import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class DeletePetUsecase {
  final ProfileRepository _profileRepository;

  DeletePetUsecase(this._profileRepository);

  Future<bool> run(int petId) {
    return _profileRepository.deletePet(petId);
  }
}
