import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';

class PetVaccinateCreatedEvent {
  final PetVaccinated _petVaccinated;

  PetVaccinateCreatedEvent(this._petVaccinated);
}
