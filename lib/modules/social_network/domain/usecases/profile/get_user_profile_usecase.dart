import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class GetUseProfileUseacse {
  final ProfileRepository _profileRepository;

  GetUseProfileUseacse(this._profileRepository);

  Future<Map<String, dynamic>> call(int userId) async {
    return _profileRepository.getUserProfile(userId);
  }
}
