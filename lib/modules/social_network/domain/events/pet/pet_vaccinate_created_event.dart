import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';

class PetVaccinateCreatedEvent {
  final PetVaccinated petVaccinated;

  PetVaccinateCreatedEvent(this.petVaccinated);
}
