import 'package:flutter/material.dart';
import 'package:meowoof/theme/ui_color.dart';

class MWAlert extends StatefulWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsets padding;
  final BorderRadiusGeometry? borderRadius;
  final Color color;

  const MWAlert(
      {super.key,
      required this.child,
      this.height,
      this.width,
      this.padding = const EdgeInsets.all(15),
      this.borderRadius,
      this.color = UIColor.holder,});

  @override
  MWAlertState createState() {
    return MWAlertState();
  }
}

class MWAlertState extends State<MWAlert> {
  late bool isVisible;

  @override
  void initState() {
    super.initState();
    isVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
      ),
      child: widget.child,
    );
  }
}
