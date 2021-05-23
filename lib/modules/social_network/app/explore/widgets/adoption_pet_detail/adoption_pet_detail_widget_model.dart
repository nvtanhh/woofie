import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AdoptionPetDetailWidgetModel extends BaseViewModel {
  late Post post;
  Pet? pet;
}
