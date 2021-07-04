import 'package:json_annotation/json_annotation.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
part 'notification.g.dart';
@JsonSerializable(explicitToJson: true)
class Notification{
  int id;
  int actor_id;
  User actor;
  
}