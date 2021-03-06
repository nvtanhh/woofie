import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/map/widgets/filter/models/filter_option.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class GetPostByLocationUsecase {
  final ExploreRepository _exploreRepository;

  GetPostByLocationUsecase(this._exploreRepository);

  Future<List<Post>> call({
    required double lat,
    required double long,
    required int radius,
    FilterOptions? filterOptions,
  }) {
    return _exploreRepository.getPostsByLocation(
      lat,
      long,
      radius,
      filterOptions: filterOptions,
    );
  }
}
