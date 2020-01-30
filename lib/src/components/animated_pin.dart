import 'package:flutter/material.dart';

class AnimatedPin extends StatefulWidget {
  AnimatedPin({
    Key key,
    this.child,
  });

  final Widget child;

  @override
  _AnimatedPinState createState() => _AnimatedPinState();
}

class _AnimatedPinState extends State<AnimatedPin>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return JumpingContainer(controller: _controller, child: widget.child);
  }
}

class JumpingContainer extends AnimatedWidget {
  const JumpingContainer({
    Key key,
    AnimationController controller,
    this.child,
  }) : super(key: key, listenable: controller);

  final Widget child;

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -10 + _progress.value * 10),
      child: child,
    );
  }
}
