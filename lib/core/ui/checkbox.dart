import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/icon.dart';

class MWCheckbox extends StatelessWidget {
  final bool value;
  final OBCheckboxSize size;

  const MWCheckbox({
    Key? key,
    required this.value,
    this.size = OBCheckboxSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: MWIcon(
            value ? MWIcons.checkCircleSelected : MWIcons.checkCircle,
            customSize: 20,
            themeColor: value
                ? MWIconThemeColor.success
                : MWIconThemeColor.secondaryText,
          ),
        ),
      ),
    );
  }
}

enum OBCheckboxSize { medium }
