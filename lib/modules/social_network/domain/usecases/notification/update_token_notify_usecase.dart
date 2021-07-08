import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/notification_repository.dart';

@lazySingleton
class UpdateTokenNotifyUsecase {
  final NotificationRepository _notificationRepository;

  UpdateTokenNotifyUsecase(this._notificationRepository);
  Future run(String tokenNotify) {
    return _notificationRepository.updateTokenNotify(tokenNotify);
  }
}
