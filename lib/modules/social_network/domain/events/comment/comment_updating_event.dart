import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';

class CommentUpdatingEvent {
  final Comment comment;
  CommentUpdatingEvent(this.comment);
}
