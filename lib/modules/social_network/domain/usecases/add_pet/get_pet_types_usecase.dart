import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/add_pet_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';

@lazySingleton
class GetPetTypesUsecase {
  final AddPetRepository _addPetRepository;

  GetPetTypesUsecase(this._addPetRepository);

  Future<List<PetType>> call() {
    return _addPetRepository.getPetTypes();
  }
}
