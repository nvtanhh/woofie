import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/notification_repository.dart';

@lazySingleton
class CountNotificationUnreadUsecase {
  final NotificationRepository _notificationRepository;

  CountNotificationUnreadUsecase(this._notificationRepository);
  Future<int> run() {
    return _notificationRepository.countNotificationUnread();
  }
}
