import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double size;
  final Color?  color;

  const AppIcon({
    super.key,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color ?? Theme.of(context).primaryColor,
            (color ?? Theme.of(context).primaryColor).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow:  [
          BoxShadow(
            color: (color ?? Theme.of(context).primaryColor).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.cloud,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
}