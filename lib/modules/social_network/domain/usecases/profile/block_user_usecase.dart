import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class BlockUserUsecase {
  final ProfileRepository _profileRepository;

  BlockUserUsecase(this._profileRepository);
}
