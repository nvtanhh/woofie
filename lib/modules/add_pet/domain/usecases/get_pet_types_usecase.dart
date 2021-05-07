import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/data/repositories/add_pet_repositories.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_type.dart';

@lazySingleton
class GetPetTypesUsecase {
  final AddPetRepository _addPetRepository;

  GetPetTypesUsecase(this._addPetRepository);

  Future<List<PetType>> call() {
    return _addPetRepository.getPetTypes();
  }
}
