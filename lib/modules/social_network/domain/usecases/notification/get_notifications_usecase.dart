import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/notification_repository.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification.dart';

@lazySingleton
class GetNotificationUsecase {
  final NotificationRepository _notificationRepository;

  GetNotificationUsecase(this._notificationRepository);
  Future<List<Notification>> run({int limit = 10, int offset = 0}) {
    return _notificationRepository.getNotification(limit, offset);
  }
}
