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
    final listUserTag = userTag.map((e) => {"user_id": e.id, "post_id": postId}).toList();
    final mutation = """
mutation MyMutation {
  insert_comments_one(object: {content: "$content", post_id: $postId, comment_tag_users: {data: ${listUserTag.toString()}}}) {
    created_at
    content
    id
    creator_uuid
    post_id
    user {
      avatar_url
      name
      id
      uuid
    }
  }
}
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_comments_one"] as Map;
    return Comment.fromJson(affectedRows as Map<String, dynamic>);
  }

  Future<bool> likeComment(
    int idComment,
    int idPost,
  ) async {
    final mutation = """
    mutation MyMutation {
      likeComment(post_id: $idPost,comment_id: $idComment) {
        id
      }
    }
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["likeComment"] as Map;
    return int.tryParse("${affectedRows["id"]}") != null;
  }

  Future deleteComment(int commentId) async {
    final manution = """
mutation MyMutation {
  delete_comments_by_pk(id: $commentId) {
    id
  }
}
    """;
    final data = await _hasuraConnect.mutation(manution);
    GetMapFromHasura.getMap(data as Map)["delete_comments_by_pk"] as Map;
    return;
  }

  Future reportComment(Comment comment, String content) async {
    final manution = """
    mutation MyMutation {
    insert_report_comment(objects: {comment_id: ${comment.id} ,content: "$content", post_id: ${comment.postId!}, type: 0}) {
    affected_rows
    }
    }
    """;
    final data = await _hasuraConnect.mutation(manution);
    GetMapFromHasura.getMap(data as Map)["insert_report_comment"] as Map;
    return;
  }

  Map<String, List<int>> d(
    List<User> uOld,
    List<User> uNew,
  ) {
    // ignore: avoid_function_literals_in_foreach_calls
    Map<String, List<int>> map = {};
    int i = 0;
    int j = 0;
    bool contain = false;
    // deleted
    for (; i < uOld.length; i++) {
      contain = false;
      for (j = 0; j < uNew.length; j++) {
        if (uOld[i].id == uNew[j].id) {
          contain = true;
          continue;
        }
      }
      if (contain == false) {
        map.update("remove", (data) {
          data.add(uOld[i].id);
          return data;
        }, ifAbsent: () => [uOld[i].id]);
      }
    }
    i = 0;
    //add
    for (; i < uNew.length; i++) {
      contain = false;
      for (j = 0; j < uOld.length; j++) {
        if (uOld[j].id == uNew[i].id) {
          contain = true;
          continue;
        }
      }
      if (contain == false) {
        map.update("add", (data) {
          data.add(uNew[i].id);
          return data;
        }, ifAbsent: () => [uNew[i].id]);
      }
    }
    return map;
  }

  Future<int> deleteCommentTagUsers(List<int> userIds, int commentId) async {
    final manution = """
   mutation MyMutation {
  delete_comment_tag_user(where: {_and: {user_id: {_in: ${userIds.toString()}}, comment_id: {_eq: $commentId}}}) {
    affected_rows
    }
    }
    """;
    print(manution);
    final data = await _hasuraConnect.mutation(manution);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["delete_comment_tag_user"] as Map;
    return affectedRows["affected_rows"] as int;
  }

  Future<int> addCommentTagUser(List<int> userIds, int commentId, int postId) async {
    final users = userIds.map((e) => {"user_id": e, "post_id": postId, "comment_id": commentId}).join(",");
    final manution = """
    mutation MyMutation {
    insert_comment_tag_user(objects: [$users]) {
    affected_rows
    }
    }
    """;
    print(manution);
    final data = await _hasuraConnect.mutation(manution);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["insert_comment_tag_user"] as Map;
    return affectedRows["affected_rows"] as int;
  }

  Future<int> deleteOrAddCommentTagUser(List<int> usersAdd, List<int> usersDelete, int commentId, int postId) async {
    final users = usersAdd.map((e) => {"user_id": e, "post_id": postId, "comment_id": commentId}).join(",");
    final manution = """
    mutation MyMutation {
    insert_comment_tag_user(objects: [$users]) {
    affected_rows
    }
    delete_comment_tag_user(where: {_and: {user_id: {_in: ${usersDelete.toString()}}, comment_id: {_eq: $commentId}}}) {
    affected_rows
    }
    }
    """;
    print(manution);
    final data = await _hasuraConnect.mutation(manution);
    final affectedRowsInsert = GetMapFromHasura.getMap(data as Map)["insert_comment_tag_user"] as Map;
    final affectedRowsDelete = GetMapFromHasura.getMap(data)["delete_comment_tag_user"] as Map;
    return (affectedRowsInsert["affected_rows"] as int) + (affectedRowsDelete["affected_rows"] as int);
  }

  Future<Comment> editComment(Comment oldComment, Comment newComment) async {
    Map<String, List<int>> map;
    // nothing change
    if (oldComment.content == newComment.content) {
      return oldComment;
    } else {
      print(oldComment.commentTagUser?.length);
      print(newComment.commentTagUser?.length);
      // check change tagUser
      map = d(oldComment.commentTagUser!, newComment.commentTagUser!);
    }
    int affectedRows = 0;
    if (map.isNotEmpty) {
      print("isNotEmpty");
      if (map.length == 2) {
        print("map.length == 2");
        affectedRows = await deleteOrAddCommentTagUser(map["add"]!, map["remove"]!, oldComment.id, oldComment.postId!);
      } else {
        print("map.length != 2");
        if (map["remove"]?.isNotEmpty == true) {
          print('map["remove"]?.isNotEmpty == true');
          affectedRows = await deleteCommentTagUsers(map["remove"]!, oldComment.id);
        }
        if (map["add"]?.isNotEmpty == true) {
          print('map["add"]?.isNotEmpty == true');
          affectedRows = await addCommentTagUser(map["add"]!, oldComment.id, oldComment.postId!);
        }
      }
    }
    final manution = """
    mutation MyMutation {
    update_comments_by_pk(pk_columns: {id: ${oldComment.id}}, _set: {content: "${newComment.content}"}) {
    created_at
    content
    id
    }
    }
    """;
    final data = await _hasuraConnect.mutation(manution);
    final comment = GetMapFromHasura.getMap(data as Map)["update_comments_by_pk"] as Map<String, dynamic>;
    return Comment.fromJson(comment);
  }
}
