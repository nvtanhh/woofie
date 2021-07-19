import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PostLocator extends StatelessWidget {
  final int? maxLines;

  final int? iconSize;

  final Location? location;

  const PostLocator({Key? key, required this.location, this.maxLines = 1, this.iconSize = 20}) : super(key: key);

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
                  location!.toPresent(),
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
