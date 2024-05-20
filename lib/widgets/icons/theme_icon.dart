import 'package:flutter/material.dart';

class ThemeIcon extends StatelessWidget {
  const ThemeIcon(
    this.icon, {
    Key? key,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
  }) : super(key: key);

  final IconData icon;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final List<Shadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: Theme.of(context).iconTheme.size,
      color: Theme.of(context).iconTheme.color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      shadows: shadows,
    );
  }
}
