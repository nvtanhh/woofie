import 'package:meowoof/modules/social_network/domain/models/user.dart';

class PetOwnerHistory {
  final User owner;
  final DateTime? giveTime;
  final DateTime? createdAt;
  PetOwnerHistory({
    required this.owner,
    this.giveTime,
    this.createdAt,
  });

  factory PetOwnerHistory.fromJson(Map<String, dynamic> json) {
    return PetOwnerHistory(
      owner: User.fromJson(json['owner'] as Map<String, dynamic>),
      giveTime: json['give_time'] == null
          ? null
          : DateTime.parse(json['give_time'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }

  bool isCurrentOwner() {
    return giveTime == null;
  }
}
