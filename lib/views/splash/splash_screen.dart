import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/animated_logo.dart';
import 'widgets/splash_text.dart';

/// SmartSplit Splash Screen
/// 
/// Features:
/// - 3-second total duration with phased animations
/// - Logo: scale, rotation, opacity, and breathing pulse effect
/// - Text: fade in and slide up animations with staggered timing
/// - Platform-adaptive loading indicator
/// - First-launch detection using Hive database
/// - Smooth exit transition with fade and scale
/// - Responsive design supporting multiple screen sizes
/// - Accessibility support with semantic labels
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late AnimationController _exitController;

  // Logo Animations (Phase 1: 0.0s - 1.2s)
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotation;

  // Text Animations (Phase 2: 0.8s - 1.8s)
  late Animation<double> _appNameOpacity;
  late Animation<Offset> _appNameSlide;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;

  // Pulse Animation (Phase 3: 1.5s - 3.0s)
  late Animation<double> _pulseScale;

  // Exit Animation (Phase 4: 2.8s - 3.2s)
  late Animation<double> _exitOpacity;
  late Animation<double> _exitScale;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _navigateAfterDelay();
  }

  /// Initialize all animation controllers and animations
  void _setupAnimations() {
    // Phase 1: Logo Entry Animation (1.2 seconds)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _logoRotation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Phase 2: Text Animations (1.0 second total, starting at 0.8s)
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // App Name: Starts immediately when text controller begins
    _appNameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _appNameSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    // Tagline: Delayed by 0.3s (using interval 0.3 - 0.8)
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Phase 3: Pulse Animation (breathing effect from 1.5s onwards)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Phase 4: Exit Animation (0.4 seconds)
    _exitController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeInCubic,
      ),
    );

    _exitScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeInCubic,
      ),
    );
  }

  /// Start all animations with proper timing
  void _startAnimations() {
    // Phase 1: Logo animation starts immediately
    _logoController.forward();

    // Phase 2: Text animations start at 0.8s
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _textController.forward();
    });

    // Phase 3: Pulse animation starts at 1.5s and repeats
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });

    // Phase 4: Exit animation starts at 2.8s
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) _exitController.forward();
    });
  }

  /// Navigate to appropriate screen after 3 seconds
  /// First launch → Onboarding
  /// Returning user → Home
  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 3000));

    if (!mounted) return;

    try {
      // Check if first launch using Hive
      final box = await Hive.openBox('app_settings');
      final isFirstLaunch = box.get('isFirstLaunch', defaultValue: true);

      // Haptic feedback for smooth transition (optional)
      HapticFeedback.lightImpact();

      if (isFirstLaunch) {
        // Mark as not first launch
        await box.put('isFirstLaunch', false);
        
        // Navigate to onboarding
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/onboarding');
        }
      } else {
        // Navigate to home
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (e) {
      // Fallback to onboarding if there's an error
      debugPrint('Error checking first launch: $e');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // Responsive logo size
    final logoSize = _getResponsiveLogoSize(screenWidth);

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_exitOpacity, _exitScale]),
        builder: (context, child) {
          return Opacity(
            opacity: _exitOpacity.value,
            child: Transform.scale(
              scale: _exitScale.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: _buildGradientBackground(),
          child: SafeArea(
            child: Semantics(
              label: 'SmartSplit splash screen, loading application',
              child: Column(
                children: [
                  // Top spacing (60% from top for logo)
                  SizedBox(height: screenHeight * 0.35),

                  // Animated Logo
                  AnimatedLogo(
                    scaleAnimation: _logoScale,
                    opacityAnimation: _logoOpacity,
                    rotationAnimation: _logoRotation,
                    pulseAnimation: _pulseScale,
                    size: logoSize,
                  ),

                  const SizedBox(height: 24),

                  // App Name
                  AppNameText(
                    opacity: _appNameOpacity,
                    slideAnimation: _appNameSlide,
                    screenWidth: screenWidth,
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TaglineText(
                      opacity: _taglineOpacity,
                      slideAnimation: _taglineSlide,
                      screenWidth: screenWidth,
                    ),
                  ),

                  const Spacer(),

                  // Loading Indicator (Phase 3: appears around 1.5s)
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textController.value,
                        child: child,
                      );
                    },
                    child: _buildLoadingIndicator(),
                  ),

                  SizedBox(height: screenHeight * 0.08),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Get responsive logo size based on screen width
  double _getResponsiveLogoSize(double width) {
    if (width < 360) return 80; // Small screens (iPhone SE)
    if (width < 414) return 100; // Medium screens (iPhone 14)
    return 120; // Large screens (iPad)
  }

  /// Build gradient background
  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFAFAFA), // Light gray
          Color(0xFFFFFFFF), // White
        ],
      ),
    );
  }

  /// Build platform-adaptive loading indicator
  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00B4D8)),
        semanticsLabel: 'Loading',
      ),
    );
  }
}
