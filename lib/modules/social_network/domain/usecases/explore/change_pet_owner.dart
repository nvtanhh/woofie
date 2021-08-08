import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class ChangePetOwnerUsecase {
  final ExploreRepository _exploreRepository;

  ChangePetOwnerUsecase(this._exploreRepository);

  Future<bool> call(User user, Pet pet) {
    return _exploreRepository.changePetOwner(user, pet);
  }
}
