import 'package:flutter/material.dart';

class JumpingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double jumpingHeight;

  const JumpingWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.jumpingHeight = 10,
  }) : super(key: key);

  @override
  _JumpingWidgetState createState() => _JumpingWidgetState();
}

class _JumpingWidgetState extends State<JumpingWidget> with TickerProviderStateMixin {
  late AnimationController _animationControllers;
  late Animation<double> _animate;
  int animationDuration = 200;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _animationControllers.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _animationControllers = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);

    _animate = Tween<double>(begin: 0, end: 0 - widget.jumpingHeight).animate(_animationControllers);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animate,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(offset: Offset(0, _animate.value), child: child);
        },
        child: widget.child,
      ),
    );
  }
}
