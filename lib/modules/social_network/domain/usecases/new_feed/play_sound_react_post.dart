import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/events/sound/sound_play_event.dart';

@lazySingleton
class PlaySoundAddNewComment {
  final EventBus _eventBus;

  PlaySoundAddNewComment(this._eventBus);

  Future run() async {
    _eventBus.fire(SoundPlayEvent(SoundType.addNew));
    return;
  }
}
