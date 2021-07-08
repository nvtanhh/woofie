import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/add_pet_repository.dart';
import 'package:meowoof/modules/social_network/domain/events/pet/pet_created_event.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

@lazySingleton
class AddPetUsecase {
  final AddPetRepository _addPetRepository;
  final EventBus _eventBus;
  AddPetUsecase(this._addPetRepository, this._eventBus);

  Future<Pet> call(Pet pet) async {
    final myPet = await _addPetRepository.addPet(pet);
    _eventBus.fire(PetCreatedEvent(myPet));
    return myPet;
  }
}
