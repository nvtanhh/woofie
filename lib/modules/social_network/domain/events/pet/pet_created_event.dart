import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

class PetCreatedEvent {
  final Pet pet;

  PetCreatedEvent(this.pet);
}
