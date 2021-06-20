import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

@lazySingleton
class SearchPetUsecase {
  final ExploreRepository _exploreRepository;

  SearchPetUsecase(this._exploreRepository);

  Future<List<Pet>> call(String keyWord, {int offset = 0, int limit = 10}) {
    return _exploreRepository.searchPet(keyWord, offset, limit);
  }
}
