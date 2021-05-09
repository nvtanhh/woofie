import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/newfeed/data/datasources/newfeed_datasources.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';

@lazySingleton
class NewFeedRepository {
  final NewFeedDatasource _newFeedDatasource;

  NewFeedRepository(this._newFeedDatasource);

  Future<List<Post>> getPosts() {
    return _newFeedDatasource.getPosts();
  }
}
