import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

@lazySingleton
class GetPetsOfUserUsecase {
  final NewFeedRepository _newFeedRepository;

  GetPetsOfUserUsecase(this._newFeedRepository);

  Future<List<Pet>> call(String userUUID) {
    return _newFeedRepository.getPetsOfUser(userUUID);
  }
}
