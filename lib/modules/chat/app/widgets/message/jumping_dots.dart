import 'package:flutter/material.dart';

class JumpingDots extends StatefulWidget {
  final int numberOfDots;
  final Color? color;
  final double? radius;
  final double jumpHeight;

  const JumpingDots({
    Key? key,
    this.numberOfDots = 3,
    this.color,
    this.radius = 5,
    this.jumpHeight = 10,
  }) : super(key: key);

  @override
  _JumpingDotsState createState() => _JumpingDotsState();
}

class _JumpingDotsState extends State<JumpingDots> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late final List<Animation<double>> _animations = [];
  int animationDuration = 200;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initAnimation() {
    ///initialization of _animationControllers
    ///each _animationController will have same animation duration
    _animationControllers = List.generate(
      widget.numberOfDots,
      (index) {
        return AnimationController(vsync: this, duration: Duration(milliseconds: animationDuration));
      },
    ).toList();

    ///initialization of _animations
    ///here end value is -20
    ///end value is amount of jump.
    ///and we want our dot to jump in upward direction
    for (int i = 0; i < widget.numberOfDots; i++) {
      _animations.add(Tween<double>(begin: 0, end: widget.jumpHeight).animate(_animationControllers[i]));
    }
    for (int i = 0; i < widget.numberOfDots; i++) {
      _animationControllers[i].addStatusListener((status) {
        //On Complete
        if (status == AnimationStatus.completed) {
          //return of original postion
          _animationControllers[i].reverse();
          //if it is not last dot then start the animation of next dot.
          if (i != widget.numberOfDots - 1) {
            _animationControllers[i + 1].forward();
          }
        }
        //if last dot is back to its original postion then start animation of the first dot.
        // now this animation will be repeated infinitely
        if (i == widget.numberOfDots - 1 && status == AnimationStatus.dismissed) {
          _animationControllers[0].forward();
        }
      });
    }
    //trigger animtion of first dot to start the whole animation.
    _animationControllers.first.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.numberOfDots, (index) {
          //AnimatedBuilder widget will rebuild it self when
          //_animationControllers[index] value changes.
          return AnimatedBuilder(
            animation: _animationControllers[index],
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(2.5),
                child: Transform.translate(
                  offset: Offset(0, _animations[index].value),
                  child: DotWidget(
                    color: widget.color,
                    radius: widget.radius,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class DotWidget extends StatelessWidget {
  final double? radius;
  final Color? color;

  const DotWidget({Key? key, this.color = Colors.black, this.radius = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      width: radius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
