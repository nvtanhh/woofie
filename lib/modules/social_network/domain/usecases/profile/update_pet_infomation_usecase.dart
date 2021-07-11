import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/gender.dart';

@lazySingleton
class UpdatePetInformationUsecase {
  final ProfileRepository _profileRepository;

  UpdatePetInformationUsecase(this._profileRepository);

  Future<Map<String, dynamic>> run(
    int petId, {
    String? name,
    String? bio,
    int? breed,
    String? avatarUrl,
    DateTime? dob,
    String? uuid,
    Gender? gender,
  }) {
    return _profileRepository.updatePetInformation(
      petId,
      name,
      bio,
      breed,
      avatarUrl,
      uuid,
      dob,
      gender,
    );
  }
}
