import 'package:flutter/material.dart';

/// Animated logo widget with scale, rotation, and opacity animations
/// Provides a breathing pulse effect during the splash screen
class AnimatedLogo extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;
  final Animation<double> rotationAnimation;
  final Animation<double> pulseAnimation;
  final double size;

  const AnimatedLogo({
    Key? key,
    required this.scaleAnimation,
    required this.opacityAnimation,
    required this.rotationAnimation,
    required this.pulseAnimation,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        scaleAnimation,
        opacityAnimation,
        rotationAnimation,
        pulseAnimation,
      ]),
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.scale(
            scale: scaleAnimation.value * pulseAnimation.value,
            child: Transform.rotate(
              angle: rotationAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: _buildLogo(),
    );
  }

  Widget _buildLogo() {
    // Custom logo with split icon representing expense splitting
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00B4D8), // Modern teal
            Color(0xFF0077B6), // Deep blue
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4D8).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Split icon - vertical divider line
          Container(
            width: 3,
            height: size * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Left money symbol
          Positioned(
            left: size * 0.2,
            child: _buildMoneyIcon(size * 0.3),
          ),
          // Right money symbol
          Positioned(
            right: size * 0.2,
            child: _buildMoneyIcon(size * 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyIcon(double iconSize) {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '\$',
          style: TextStyle(
            fontSize: iconSize * 0.6,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0077B6),
          ),
        ),
      ),
    );
  }
}
