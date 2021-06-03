import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';

@lazySingleton
class ReportUserUsecase {
  final ProfileRepository _profileRepository;

  ReportUserUsecase(this._profileRepository);

  Future reportUser(int userID) {
    return _profileRepository.reportUser(userID);
  }
}
