import 'package:flutter/material.dart';

class DiscoverActionButton extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback? onPressed;
  final double size;

  const DiscoverActionButton({
    super.key,
    required this.icon,
    required this.gradient,
    this.onPressed,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.45),
      ),
    );
  }
}
