import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/notification_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/user_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification.dart';

@lazySingleton
class NotificationRepository {
  final UserDatasource _userDatasource;
  final NotificationDatasource _notificationDatasource;
  NotificationRepository(this._userDatasource, this._notificationDatasource);

  Future updateTokenNotify(String tokenNotify) {
    return _userDatasource.updateTokenNotify(tokenNotify);
  }

  Future<List<Notification>> getNotification(int limit, int offset) {
    return _notificationDatasource.getNotification(limit, offset);
  }

  Future<int> countNotificationUnread() {
    return _notificationDatasource.countNotificationUnread();
  }

  Future readAllNotification() {
    return _notificationDatasource.readAllNotification();
  }
}
