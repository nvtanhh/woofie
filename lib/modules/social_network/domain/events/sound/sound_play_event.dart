class SoundPlayEvent {
  SoundType soundType;

  SoundPlayEvent(this.soundType);
}

enum SoundType { addNew, receiverComment, reactPost }
