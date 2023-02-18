import 'package:easy_localization/easy_localization.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/gender.dart';

class FormatHelper {
  static String formatNumber(num value, {String pattern = "#,###.##"}) {
    final formatter = NumberFormat(pattern);
    return formatter.format(value);
  }

  static String formatDateTime(DateTime? dateTime,
      {String pattern = "E, d MMM yyyy - HH:mm",}) {
    if (dateTime == null) {
      return '';
    }
    final dateFormatter = DateFormat(pattern);
    return dateFormatter.format(dateTime);
  }

  static String genderPet(Gender? gender) {
    if (gender == null) return "Unknown";
    switch (gender.index) {
      case 0:
        return LocaleKeys.add_pet_pet_male.trans();
      case 1:
        return LocaleKeys.add_pet_pet_female.trans();
      default:
        return "Unknown";
    }
  }
}
