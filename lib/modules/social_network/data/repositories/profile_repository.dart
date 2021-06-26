import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/pet_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/user_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class ProfileRepository {
  final UserDatasource _userDatasource;
  final PetDatasource _petDatasource;
  final PostDatasource _postDatasource;

  ProfileRepository(
    this._userDatasource,
    this._petDatasource,
    this._postDatasource,
  );

  Future likePost(int postId) async {
    return _postDatasource.likePost(postId);
  }

  Future<User> getUserProfile(int userId) async {
    return _userDatasource.getUserProfile(userId);
  }

  Future<List<Post>> getPostOfUser(String userUUID, int offset, int limit) async {
    return _postDatasource.getPostOfUser(userUUID, offset, limit);
  }

  Future<List<PetVaccinated>> getVaccinates(int idPet, int limit, int offset) async {
    return _petDatasource.getVaccinates(idPet, limit, offset);
  }

  Future<List<PetWeight>> getWeights(int idPet, int limit, int offset) async {
    return _petDatasource.getWeights(idPet, limit, offset);
  }

  Future<List<PetWormFlushed>> getWormFlushes(int idPet, int limit, int offset) async {
    return _petDatasource.getWormFlushes(idPet, limit, offset);
  }

  Future<PetVaccinated> addVaccinated(PetVaccinated petVaccinated) async {
    return _petDatasource.addVaccinated(petVaccinated);
  }

  Future<PetWormFlushed> addWormFlushed(PetWormFlushed petWormFlushed) async {
    return _petDatasource.addWormFlushed(petWormFlushed);
  }

  Future<PetWeight> addWeight(PetWeight petWeight) async {
    return _petDatasource.addWeight(petWeight);
  }

  Future<List<Post>> getPostsOfPet(int petId, int offset, int limit) async {
    return _postDatasource.getPostsOfPet(petId, offset, limit);
  }

  Future<Pet> getDetailInfoPet(int idPet) async {
    return _petDatasource.getDetailInfoPet(idPet);
  }

  Future followPet(int petID) {
    return _userDatasource.followPet(petID);
  }

  Future blockUser(int userID) async {
    return _userDatasource.blockUser(userID);
  }

  Future reportUser(int userID) {
    return _userDatasource.reportUser(userID);
  }

  Future<bool> deletePost(int idPost) {
    return _postDatasource.deletePost(idPost);
  }
}
