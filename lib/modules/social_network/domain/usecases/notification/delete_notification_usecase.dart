import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/notification_repository.dart';

@lazySingleton
class DeleteNotificationUsecase {
  final NotificationRepository _notificationRepository;

  DeleteNotificationUsecase(this._notificationRepository);
  Future run(int notifyId) {
    return _notificationRepository.deleteNotificationUnread(notifyId);
  }
}
