import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class UserProfileModel extends BaseViewModel {
  User? user;

  @override
  void initState() {
    user ??= injector<LoggedInUser>().loggedInUser;
    super.initState();
  }
}
