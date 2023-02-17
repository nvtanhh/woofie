import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class IconWithBagedWidget extends StatelessWidget {
  final Function goToRequestMessagePage;
  final int count;

  const IconWithBagedWidget(
      {Key? key, required this.goToRequestMessagePage, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: MWIcon(MWIcons.requestMessage),
          onPressed: () => goToRequestMessagePage(),
        ),
        if (count > 0)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: UIColor.danger,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
      ],
    );
  }
}
