import 'package:flutter/material.dart';

class DrawerAnimation extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  const DrawerAnimation({super.key, required this.child, required this.isOpen});

  @override
  State<DrawerAnimation> createState() => _DrawerAnimationState();
}

class _DrawerAnimationState extends State<DrawerAnimation>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> tween;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    tween = Tween(
            begin: widget.isOpen ? -50.0 : 0.0,
            end: widget.isOpen ? 0.0 : -50.0)
        .animate(animationController);
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tween,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(tween.value, 0),
        );
      },
      child: widget.child,
    );
  }
}
