import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final Widget child;
  final Color? hoverColor;
  final Color? color;
  final Color? splashColor;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final void Function()? onPressed;
  const HoverButton({
    super.key,
    required this.child,
    this.hoverColor,
    this.color,
    this.padding,
    required this.onPressed,
    this.border,
    this.splashColor,
    this.borderRadius,
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return /* MouseRegion(
      onEnter: (event) => setState(() {
        isHover = true;
      }),
      onExit: (event) => setState(() {
        isHover = false;
      }),
      child: */
        InkWell(
      onHover: (v) => setState(() {
        isHover = v;
      }),
      borderRadius: widget.borderRadius,
      splashColor: widget.splashColor,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        padding: widget.padding,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeIn,
        child: widget.child,
        decoration: BoxDecoration(
          color: isHover ? widget.hoverColor : widget.color,
          borderRadius: widget.borderRadius,
          border: widget.border,
        ),
      ),
    );
    /*  ); */
  }
}
