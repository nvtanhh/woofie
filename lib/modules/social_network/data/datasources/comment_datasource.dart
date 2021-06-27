import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';

@injectable
class CommentDatasource {
  final HasuraConnect _hasuraConnect;

  CommentDatasource(this._hasuraConnect);

  Future<Comment?> createComment(int postId, String content) async {
    return Comment(id: 2);
  }

  Future<bool> likeComment(int idComment) async {
    return true;
  }
}
