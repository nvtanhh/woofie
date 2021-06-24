import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';

class PetWormFlushCreatedEvent {
  final PetWormFlushed petWormFlushed;

  PetWormFlushCreatedEvent(this.petWormFlushed);
}
