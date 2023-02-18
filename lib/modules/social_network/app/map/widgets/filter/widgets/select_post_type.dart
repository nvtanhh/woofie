import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';

class MapSeacherFilterSelectPostTypeWidget extends StatelessWidget {
  final List<PostType> selectedPostTypes;
  final Function(PostType) onPostTypeSelected;

  const MapSeacherFilterSelectPostTypeWidget({
    super.key,
    required this.onPostTypeSelected,
    this.selectedPostTypes = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _builtPostTypeWidget(PostType.adop),
        SizedBox(width: 15.w),
        _builtPostTypeWidget(PostType.mating),
        SizedBox(width: 15.w),
        _builtPostTypeWidget(PostType.lose),
      ],
    );
  }

  MWIconData defineIcon(PostType postType) {
    switch (postType) {
      case PostType.mating:
        return MWIcons.icMatingBold;
      case PostType.adop:
        return MWIcons.icAdoptionBold;
      case PostType.lose:
        return MWIcons.icLose;
      default:
        return MWIcons.icAdoption;
    }
  }

  Widget _builtPostTypeWidget(PostType type) {
    return GestureDetector(
      onTap: () => onPostTypeSelected(type),
      child: Opacity(
        opacity: selectedPostTypes.contains(type) ? 1 : .3,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.w),
            border: Border.all(
              width: 1.5.w,
              color: selectedPostTypes.contains(type)
                  ? _getColor(type)
                  : UIColor.antiqueWhite,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(2.5.w),
            child: MWIcon(
              defineIcon(type),
              customSize: 48.w,
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(PostType type) {
    switch (type) {
      case PostType.activity:
        return Colors.transparent;
      case PostType.adop:
        return UIColor.adoptionColor;
      case PostType.mating:
        return UIColor.matingColor;
      case PostType.lose:
        return UIColor.danger;
    }
  }
}
