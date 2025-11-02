import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Animated text components for splash screen
/// Includes app name and tagline with fade and slide animations
class SplashText extends StatelessWidget {
  final Animation<double> opacity;
  final Animation<Offset> slideAnimation;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const SplashText({
    Key? key,
    required this.opacity,
    required this.slideAnimation,
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([opacity, slideAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: opacity,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: const Color(0xFF0077B6),
          letterSpacing: fontWeight == FontWeight.bold ? 1.2 : 0.5,
        ),
      ),
    );
  }
}

/// App name with bold styling
class AppNameText extends StatelessWidget {
  final Animation<double> opacity;
  final Animation<Offset> slideAnimation;
  final double screenWidth;

  const AppNameText({
    Key? key,
    required this.opacity,
    required this.slideAnimation,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Responsive font size based on screen width
    double fontSize = _getResponsiveFontSize(screenWidth);

    return SplashText(
      opacity: opacity,
      slideAnimation: slideAnimation,
      text: 'SmartSplit',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  double _getResponsiveFontSize(double width) {
    if (width < 360) return 28; // Small screens (iPhone SE)
    if (width < 414) return 32; // Medium screens (iPhone 14)
    return 36; // Large screens (iPad)
  }
}

/// Tagline with regular styling
class TaglineText extends StatelessWidget {
  final Animation<double> opacity;
  final Animation<Offset> slideAnimation;
  final double screenWidth;

  const TaglineText({
    Key? key,
    required this.opacity,
    required this.slideAnimation,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Responsive font size based on screen width
    double fontSize = _getResponsiveFontSize(screenWidth);

    return SplashText(
      opacity: opacity,
      slideAnimation: slideAnimation,
      text: 'Smart Splits, Fair Settlements',
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
    );
  }

  double _getResponsiveFontSize(double width) {
    if (width < 360) return 14; // Small screens
    if (width < 414) return 16; // Medium screens
    return 18; // Large screens
  }
}
