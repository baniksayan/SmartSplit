import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view_models/home/home_view_model.dart';
import 'widgets/home_header.dart';
import 'widgets/action_card.dart';
import 'widgets/recent_activity_card.dart';
import 'widgets/empty_activity_widget.dart';
import 'widgets/bottom_nav_bar.dart';

/// Home Screen Dashboard
/// 
/// Main landing screen after onboarding.
/// Features:
/// - User profile header with greeting
/// - Action cards (Restaurant Split, Shared Living)
/// - Recent activity feed
/// - Bottom navigation bar
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel _viewModel = HomeViewModel();
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _viewModel.loadHomeData();
    if (mounted) setState(() {});
  }

  Future<void> _handleRefresh() async {
    await _viewModel.refreshHomeData();
    if (mounted) setState(() {});
  }

  void _handleNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // Navigate based on index
    switch (index) {
      case 0: // Home - already here
        break;
      case 1: // Groups
        _viewModel.navigateToSharedLiving(context);
        break;
      case 2: // Reports
        Navigator.of(context).pushNamed('/reports');
        break;
      case 3: // Settings
        _viewModel.navigateToSettings(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          HomeHeader(
            userName: _viewModel.getUserName(),
            greeting: _viewModel.getGreetingText(),
            profilePicturePath: _viewModel.getUserProfilePicture(),
            onSettingsTap: () => _viewModel.navigateToSettings(context),
          ),

          // Body with pull-to-refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: const Color(0xFF00B4D8),
              child: _viewModel.isLoading
                  ? _buildLoadingState()
                  : _buildContent(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _handleNavTap,
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF00B4D8),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        // Action Cards Section
        _buildActionCards(),
        const SizedBox(height: 32),

        // Recent Activity Section
        _buildRecentActivitySection(),
      ],
    );
  }

  Widget _buildActionCards() {
    return Column(
      children: [
        // Restaurant Split Card
        ActionCard(
          title: 'Restaurant Split',
          subtitle: 'Split bills instantly\nwith your friends',
          icon: Icons.restaurant,
          gradientColors: const [Color(0xFF00B4D8), Color(0xFF0077B6)],
          metadata: _viewModel.formatLastUsage(
            _viewModel.getLastRestaurantSplitTime(),
          ),
          onTap: () => _viewModel.navigateToRestaurantSplit(context),
        ),
        const SizedBox(height: 16),

        // Shared Living Card
        ActionCard(
          title: 'Shared Living',
          subtitle: 'Track expenses with\nroommates & groups',
          icon: Icons.home,
          gradientColors: const [Color(0xFF0077B6), Color(0xFF023E8A)],
          metadata: _viewModel.activeGroupCount > 0
              ? 'Active groups: ${_viewModel.activeGroupCount}'
              : 'No active groups',
          onTap: () => _viewModel.navigateToSharedLiving(context),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            if (_viewModel.recentActivities.isNotEmpty)
              TextButton(
                onPressed: () => _viewModel.navigateToAllActivities(context),
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00B4D8),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Activity List or Empty State
        if (_viewModel.recentActivities.isEmpty)
          EmptyActivityWidget(
            onSplitBillTap: () => _viewModel.navigateToRestaurantSplit(context),
          )
        else
          _buildActivityList(),
      ],
    );
  }

  Widget _buildActivityList() {
    return Column(
      children: _viewModel.recentActivities.map((activity) {
        return RecentActivityCard(
          activity: activity,
          subtitle: _viewModel.formatActivitySubtitle(activity),
          timestamp: _viewModel.formatRelativeTime(activity.timestamp),
          icon: _viewModel.getActivityIcon(activity.activityType),
          iconColor: _viewModel.getActivityColor(activity.activityType),
          onTap: () => _viewModel.navigateToActivityDetail(
            context,
            activity.activityId,
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
