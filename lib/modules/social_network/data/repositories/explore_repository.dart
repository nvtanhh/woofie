import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/pet_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/service_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/user_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post_reaction.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class ExploreRepository {
  final UserDatasource _userDatasource;
  final PostDatasource _postDatasource;
  final PetDatasource _petDatasource;
  final ServiceDatasource _serviceDatasource;

  ExploreRepository(this._postDatasource,
      this._petDatasource,
      this._userDatasource, this._serviceDatasource,);

  Future<List<Service>> getServicesPet() async {
    return _serviceDatasource.getServices();
  }

  Future<List<Post>> getPostsByType(PostType postType,
      double longUser,
      double latUser,
      int limit,
      int offset,) async {
    return _postDatasource.getPostByType(
      postType,
      longUser,
      latUser,
      limit,
      offset,
    );
  }

  Future<Map<String, dynamic>> getDetailPost(int postId) {
    return _postDatasource.getDetailPost(postId);
  }

  Future<List<Service>> searchService(String keyWord) async {
    await Future.delayed(const Duration(seconds: 1));
    if (keyWord.isEmpty) {
      return <Service>[];
    } else {
      return <Service>[
        Service(
          id: 0,
          name: "Animal Emergency",
          logo:
          "https://animalemergencyhospital.net/wp-content/uploads/2021/04/animal-emergency-hospital.png",
        ),
        Service(
          id: 1,
          name: "Công Ty TNHH Kimipet Việt Nam",
          logo: "https://kimipet.vn/wp-content/uploads/2017/05/logo.png",
        ),
        Service(
          id: 2,
          name: "Bệnh Viện Thú Y Petcare",
          logo:
          "https://petcare.vn/wp-content/uploads/2016/06/petcarevn_logo.png",
        ),
      ];
    }
  }

  Future<List<Pet>> searchPet(String keyWord, int offset, int limit) {
    return _petDatasource.searchPet(keyWord, offset, limit);
  }

  Future<bool> reactFunctionalPost(int postId, int? matingPetId) {
    return _postDatasource.reactFunctionalPost(postId, matingPetId);
  }

  Future<List<PostReaction>> getPostFunctionalPostReact(int postId) {
    return _postDatasource.getPostFunctionalPostReact(postId);
  }

  Future<bool> changePetOwner(User user, Pet pet) {
    return _petDatasource.changePetOwner(user, pet);
  }

  Future<List<Post>> getPostsByLocation(double lat, double long, int radius) {
    return _postDatasource.getPostsByLocation(lat, long, radius);
  }

  Future<List<User>> searchUser(String keyWord, int offset, int limit) {
    return _userDatasource.searchUser(keyWord, offset, limit);
  }

  Future<Post> hadFoundPet(Post post) {
    return _postDatasource.closePost(post);
  }
}
