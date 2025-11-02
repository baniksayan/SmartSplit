import 'package:flutter/material.dart';
import '../views/splash/splash_screen.dart';
import '../views/onboarding/welcome_slides_screen.dart';
import '../views/onboarding/profile_setup_screen.dart';
import '../views/onboarding/theme_selection_screen.dart';
import '../views/onboarding/permissions_screen.dart';
import '../views/home/home_screen.dart';
import '../views/groups/groups_screen.dart';
import '../views/reports/reports_screen.dart';
import '../views/settings/settings_screen.dart';

/// App Router
/// Handles navigation routes for SmartSplit
class AppRouter {
  // Main routes
  static const String splash = '/';
  static const String home = '/home';
  
  // Onboarding routes
  static const String welcomeSlides = '/welcome-slides';
  static const String profileSetup = '/profile-setup';
  static const String themeSelection = '/theme-selection';
  static const String permissions = '/permissions';
  
  // Feature routes
  static const String groups = '/groups';
  static const String reports = '/reports';
  static const String settingsRoute = '/settings';
  static const String restaurantSplit = '/restaurant-split';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case welcomeSlides:
        return _createFadeRoute(const WelcomeSlidesScreen());
      
      case profileSetup:
        return _createSlideRoute(const ProfileSetupScreen());
      
      case themeSelection:
        return _createSlideRoute(const ThemeSelectionScreen());
      
      case permissions:
        return _createSlideRoute(const PermissionsScreen());
      
      case home:
        return _createFadeRoute(const HomeScreen());
      
      case groups:
        return _createSlideRoute(const GroupsScreen());
      
      case reports:
        return _createSlideRoute(const ReportsScreen());
      
      case settingsRoute:
        return _createSlideRoute(const SettingsScreen());
      
      case restaurantSplit:
        return _createSlideRoute(_buildPlaceholder('Restaurant Split'));
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Create a fade transition route for smooth navigation
  static PageRoute _createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
  
  /// Create a slide transition route for onboarding flow
  static PageRoute _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
  
  /// Build placeholder screen for unimplemented routes
  static Widget _buildPlaceholder(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF00B4D8),
      ),
      body: Center(
        child: Text('$title - Coming Soon'),
      ),
    );
  }
}
