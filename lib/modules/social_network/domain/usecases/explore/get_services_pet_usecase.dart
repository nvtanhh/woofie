import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';

@lazySingleton
class GetServicesPetUsecase {
  final ExploreRepository _exploreRepository;

  GetServicesPetUsecase(this._exploreRepository);

  Future<List<Service>> call() {
    return _exploreRepository.getServicesPet();
  }
}
