import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';

@lazySingleton
class SearchServiceUsecase {
  final ExploreRepository _exploreRepository;

  SearchServiceUsecase(this._exploreRepository);

  Future<List<Service>> call(String keyWord, {int offset = 0, int limit = 10}) {
    return _exploreRepository.searchService(keyWord, limit, offset);
  }
}
