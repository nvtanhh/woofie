import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';

@lazySingleton
class UpdateLocationUsecase {
  final ProfileRepository _profileRepository;

  UpdateLocationUsecase(this._profileRepository);

  Future<UserLocation> run(
      {required int id,
      required double long,
      required double lat,
      required String name,}) {
    return _profileRepository.updateLocation(id, long, long, name);
  }
}
