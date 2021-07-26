import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';

class CommentUpdatedEvent {
  final Comment comment;
  CommentUpdatedEvent(this.comment);
}
