import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/notification_repository.dart';

@lazySingleton
class ReadAllNotificationUsecase {
  final NotificationRepository _notificationRepository;

  ReadAllNotificationUsecase(this._notificationRepository);
  Future<int?> run() {
    return _notificationRepository.readAllNotification();
  }
}
