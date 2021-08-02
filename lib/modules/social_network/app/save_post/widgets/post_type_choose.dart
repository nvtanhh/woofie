import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/core/extensions/string_ext.dart';

class PostTypeChoseWidget extends StatelessWidget {
  final Function(PostType) onPostTypeChosen;
  final PostType chosenPostType;

  const PostTypeChoseWidget(
      {Key? key,
      required this.onPostTypeChosen,
      this.chosenPostType = PostType.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5.r),
              ),
              border: Border.all(
                width: 0.5,
                color: getBoderColorByType(chosenPostType),
              ),
              color: getBackgroundColorByType(chosenPostType),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: DropdownButton<PostType>(
            isDense: true,
            icon: MWIcon(
              MWIcons.arrowDown,
              size: MWIconSize.small,
              color: getTextColorByType(chosenPostType),
            ),
            underline: const SizedBox(),
            value: chosenPostType,
            onChanged: (value) {
              onPostTypeChosen(value!);
            },
            items: PostType.values
                .map((type) => _buildDropdownItem(type))
                .toList(),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<PostType> _buildDropdownItem(PostType type) {
    return DropdownMenuItem(
      value: type,
      child: Text(
        getPostTypeTile(type),
        style:
            UITextStyle.body_12_medium.apply(color: getTextColorByType(type)),
      ),
    );
  }

  static String getPostTypeTile(PostType? type) {
    switch (type) {
      case PostType.activity:
        return LocaleKeys.save_post_choose_type_activity_type.trans();
      case PostType.adop:
        return LocaleKeys.save_post_choose_type_adoption_type.trans();
      case PostType.mating:
        return LocaleKeys.save_post_choose_type_mating_type.trans();
      case PostType.lose:
        return LocaleKeys.save_post_choose_type_loss_type.trans();
      default:
        return LocaleKeys.save_post_choose_type_activity_type.trans();
    }
  }

  static Color getBoderColorByType(PostType? type) {
    switch (type) {
      case PostType.activity:
        return UIColor.textSecondary;
      case PostType.adop:
        return UIColor.adoptionColor;
      case PostType.mating:
        return UIColor.matingColor;
      case PostType.lose:
        return UIColor.danger;
      default:
        return UIColor.textSecondary;
    }
  }

  static Color getTextColorByType(PostType type) {
    switch (type) {
      case PostType.activity:
        return UIColor.textBody;
      case PostType.adop:
        return UIColor.adoptionColor;
      case PostType.mating:
        return UIColor.matingColor;
      case PostType.lose:
        return UIColor.danger;
      default:
        return UIColor.textBody;
    }
  }

  static Color getBackgroundColorByType(PostType type) {
    switch (type) {
      case PostType.activity:
        return UIColor.white;
      case PostType.adop:
        return UIColor.adoptionColorBg;
      case PostType.mating:
        return UIColor.matingColorBg;
      case PostType.lose:
        return UIColor.danger.withOpacity(.1);
      default:
        return Colors.transparent;
    }
  }
}
