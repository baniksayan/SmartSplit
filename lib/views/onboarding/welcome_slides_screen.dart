import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Welcome Tutorial Slides Screen
/// 
/// 3 slides introducing app features:
/// 1. Split Bills Fairly
/// 2. Track Shared Expenses
/// 3. Smart Settlements
/// 
/// Features:
/// - Smooth page transitions
/// - Skip button
/// - Animated page indicators
/// - "Get Started" on final slide
class WelcomeSlidesScreen extends StatefulWidget {
  const WelcomeSlidesScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeSlidesScreen> createState() => _WelcomeSlidesScreenState();
}

class _WelcomeSlidesScreenState extends State<WelcomeSlidesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      title: 'Split Bills Fairly',
      subtitle: 'Track who ate what and pay only your share',
      icon: Icons.receipt_long,
      color: Color(0xFF00B4D8),
    ),
    OnboardingSlide(
      title: 'Track Shared Expenses',
      subtitle: 'Manage daily shared expenses with ease',
      icon: Icons.groups,
      color: Color(0xFF0077B6),
    ),
    OnboardingSlide(
      title: 'Smart Settlements',
      subtitle: 'Reduce total transactions using automatic calculation',
      icon: Icons.calculate,
      color: Color(0xFF00B4D8),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skipToProfile() {
    Navigator.of(context).pushReplacementNamed('/profile-setup');
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _skipToProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo/App name
                  Text(
                    'SmartSplit',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0077B6),
                    ),
                  ),
                  // Skip button
                  if (_currentPage < _slides.length - 1)
                    TextButton(
                      onPressed: _skipToProfile,
                      child: Text(
                        'Skip',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildSlide(_slides[index]);
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _slides.length,
                effect: WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: const Color(0xFF00B4D8),
                  dotColor: Colors.grey[300]!,
                ),
              ),
            ),

            // Navigation button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B4D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: slide.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.icon,
              size: 80,
              color: slide.color,
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0077B6),
            ),
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Onboarding Slide Model
class OnboardingSlide {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
