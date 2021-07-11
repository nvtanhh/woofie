import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class UpdateUserInformationUsecase {
  final ProfileRepository _profileRepository;

  UpdateUserInformationUsecase(this._profileRepository);

  Future<Map<String, dynamic>> run(
    int userId, {
    String? name,
    String? bio,
    int? locationId,
    String? avatarUrl,
  }) {
    return _profileRepository.updateUserInformationLocation(userId, name: name, bio: bio, locationId: locationId, avatarUrl: avatarUrl);
  }
}
