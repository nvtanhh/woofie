import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostLocator extends StatelessWidget {
  final int? maxLines;

  final int? iconSize;

  final String? location;

  const PostLocator(
      {super.key, required this.location, this.maxLines = 1, this.iconSize = 20,});

  @override
  Widget build(BuildContext context) {
    return location != null
        ? Row(
            children: [
              MWIcon(
                MWIcons.location,
                themeColor: MWIconThemeColor.primary,
                customSize: iconSize!.toDouble(),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  location ?? '',
                  style: UITextStyle.body_12_medium,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
