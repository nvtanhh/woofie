import 'package:flutter/material.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/icon.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostTypeChoseWidget extends StatelessWidget {
  final Function(PostType) onPostTypeChosen;
  final PostType chosenPostType;

  const PostTypeChoseWidget({Key? key, required this.onPostTypeChosen, this.chosenPostType = PostType.activity}) : super(key: key);

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
                color: _getBoderColorByType(chosenPostType),
              ),
              color: _getBackgroundColorByType(chosenPostType),
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
              color: _getTextColorByType(chosenPostType),
            ),
            underline: const SizedBox(),
            value: chosenPostType,
            onChanged: (value) {
              onPostTypeChosen(value!);
            },
            items: PostType.values.map((type) => _buildDropdownItem(type)).toList(),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<PostType> _buildDropdownItem(PostType type) {
    return DropdownMenuItem(
      value: type,
      child: Text(
        _getPostTypeTile(type),
        style: UITextStyle.body_12_medium.apply(color: _getTextColorByType(type)),
      ),
    );
  }

  String _getPostTypeTile(PostType? type) {
    switch (type) {
      case PostType.activity:
        return 'Activity';
      case PostType.adop:
        return 'Adoption';
      case PostType.mating:
        return 'Matting';
      case PostType.lose:
        return 'Lose';
      default:
        return 'Activity';
    }
  }

  Color _getBoderColorByType(PostType? type) {
    switch (type) {
      case PostType.activity:
        return UIColor.text_secondary;
      case PostType.adop:
        return UIColor.adoption_color;
      case PostType.mating:
        return UIColor.mating_color;
      case PostType.lose:
        return UIColor.danger;
      default:
        return UIColor.text_secondary;
    }
  }

  Color _getTextColorByType(PostType type) {
    switch (type) {
      case PostType.activity:
        return UIColor.text_body;
      case PostType.adop:
        return UIColor.adoption_color;
      case PostType.mating:
        return UIColor.mating_color;
      case PostType.lose:
        return UIColor.danger;
      default:
        return UIColor.text_body;
    }
  }

  Color _getBackgroundColorByType(PostType type) {
    switch (type) {
      case PostType.activity:
        return UIColor.white;
      case PostType.adop:
        return UIColor.adoption_color_bg;
      case PostType.mating:
        return UIColor.mating_color_bg;
      case PostType.lose:
        return UIColor.danger.withOpacity(.1);
      default:
        return Colors.transparent;
    }
  }
}
