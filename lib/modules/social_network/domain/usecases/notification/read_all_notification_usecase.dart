import 'package:meowoof/modules/social_network/data/repositories/notification_repository.dart';

class ReadAllNotificationUsecase {
  final NotificationRepository _notificationRepository;

  ReadAllNotificationUsecase(this._notificationRepository);
  Future run() {
    return _notificationRepository.readAllNotification();
  }
}
