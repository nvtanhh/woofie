import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';

class PetDeletedEvent {
  final Pet pet;

  PetDeletedEvent(this.pet);
}
