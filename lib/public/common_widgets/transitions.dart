import 'package:flutter/material.dart';

class CircleTransition extends AnimatedWidget {
  const CircleTransition(
      {super.key, required this.animation, required this.child})
      : super(listenable: animation);

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ClipOval(
        clipper: _CircleClipper(animation.value),
        child: child,
      ),
    );
  }
}

class _CircleClipper extends CustomClipper<Rect> {
  _CircleClipper(this.value);

  final double value;

  @override
  Rect getClip(Size size) {
    final radius = size.width * value * 2;
    final offset = Offset(size.width / 2, size.height / 2);
    return Rect.fromCircle(center: offset, radius: radius);
  }

  @override
  bool shouldReclip(_CircleClipper oldClipper) => true;
}
