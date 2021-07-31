import 'package:audioplayers/audioplayers.dart';
import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/events/sound/sound_play_event.dart';

@singleton
class SoundDatasource {
  final EventBus _eventBus;
  final AudioCache _player = AudioCache(prefix: "resources/sounds/");

  SoundDatasource(this._eventBus) {
    _player.loadAll(["new_comment.mp3", "receiver_comment.mp3", "react_post.mp3"]);
    registerSoundEvent();
  }

  void registerSoundEvent() {
    _eventBus.on<SoundPlayEvent>().listen(
      (event) {
        switch (event.soundType) {
          case SoundType.addNew:
            playSoundAddNewComment();
            break;
          case SoundType.receiverComment:
            playSoundReceiverComment();
            break;
          case SoundType.reactPost:
            playSoundReactPost();
            break;
          default:
            playSoundAddNewComment();
            break;
        }
      },
    );
  }

  void playSoundAddNewComment() {
    _player.play("new_comment.mp3");
  }

  void playSoundReactPost() {
    _player.play("react_post.mp3");
  }

  void playSoundReceiverComment() {
    _player.play("receiver_comment.mp3");
  }
}
