import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

class PostCreatedEvent {
  final Post post;

  PostCreatedEvent(this.post);
}
