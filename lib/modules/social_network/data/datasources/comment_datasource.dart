import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@injectable
class CommentDatasource {
  final HasuraConnect _hasuraConnect;

  CommentDatasource(this._hasuraConnect);

  Future<Comment?> createComment(int postId, String content, List<User> userTag) async {
    final listPetTag = userTag.map((e) => {"user_id": e.id}).toList();
    final mutation = """
mutation MyMutation {
  insert_comments_one(object: {content: "$content", post_id: $postId, comment_tag_users: {data: ${listPetTag.toString()}}}) {
    created_at
    content
    id
    user {
      avatar_url
      name
      id
    }
  }
}
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_comments_one"] as Map;
    return Comment.fromJson(affectedRows as Map<String, dynamic>);
  }

  Future<bool> likeComment(int idComment) async {
    return true;
  }
}
