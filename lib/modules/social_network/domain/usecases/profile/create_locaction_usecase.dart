import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';

@lazySingleton
class CreateLocationUsecase {
  final ProfileRepository _profileRepository;

  CreateLocationUsecase(this._profileRepository);

  Future<Location> run({
    required double long,
    required double lat,
    required String name,
  }) {
    return _profileRepository.createLocation(long, lat, name);
  }
}
