import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

class FilterOptions {
  List<PostType>? selectedPostTypes;
  PetType? selectedPetType;
  List<PetBreed>? selectedPetBreeds;
  bool isClearFilter;
  FilterOptions({
    this.selectedPostTypes,
    this.selectedPetType,
    this.selectedPetBreeds = const [],
    this.isClearFilter = false,
  });
}
