import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';

class ActiveStatusAvatar extends StatelessWidget {
  final String avatarUrl;
  final bool isActive;

  final bool isSmallSize;

  final double borderRadius;

  const ActiveStatusAvatar({
    Key? key,
    required this.avatarUrl,
    required this.isActive,
    this.isSmallSize = false,
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3, right: 3),
          child: MWAvatar(
            avatarUrl: avatarUrl,
            borderRadius: borderRadius,
            size: isSmallSize ? MWAvatarSize.small : MWAvatarSize.medium,
          ),
        ),
        if (isActive)
          const Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 12,
              height: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xff55CA36),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          )
      ],
    );
  }
}
