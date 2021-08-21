import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class SearchUserUsecase {
  final ExploreRepository _exploreRepository;

  SearchUserUsecase(this._exploreRepository);

  Future<List<User>> call(String keyWord, {int offset = 0, int limit = 10}) {
    return _exploreRepository.searchUser(keyWord, offset, limit);
  }
}
