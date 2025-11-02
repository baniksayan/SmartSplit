import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user/user_model.dart';
import '../../models/activity/activity_model.dart';
import '../../services/database/user_service.dart';
import '../../services/database/activity_service.dart';

/// Home View Model
/// 
/// MVVM ViewModel for Home Screen Dashboard.
/// Manages user data, recent activities, and navigation.
class HomeViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final ActivityService _activityService = ActivityService();

  // State
  UserModel? currentUser;
  List<ActivityModel> recentActivities = [];
  int activeGroupCount = 0;
  bool isLoading = true;
  String? errorMessage;

  /// Load all home screen data
  Future<void> loadHomeData() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Load user data
      currentUser = await _userService.getCurrentUser();

      // Load recent activities (last 5)
      recentActivities = await _activityService.getRecentActivities(limit: 5);

      // TODO: Load active group count when group service is implemented
      activeGroupCount = 0;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load data: $e';
      notifyListeners();
      debugPrint('Error loading home data: $e');
    }
  }

  /// Refresh home screen data (pull-to-refresh)
  Future<void> refreshHomeData() async {
    await loadHomeData();
  }

  /// Get greeting text based on time of day
  String getGreetingText() {
    final hour = DateTime.now().hour;
    
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  /// Get user display name
  String getUserName() {
    return currentUser?.userName ?? 'Guest';
  }

  /// Get user profile picture path
  String? getUserProfilePicture() {
    return currentUser?.profilePicture;
  }

  /// Get user preferred currency
  String getUserCurrency() {
    return currentUser?.preferredCurrency ?? 'USD';
  }

  /// Format amount with currency symbol
  String formatAmount(double amount, {String? currency}) {
    final currencyCode = currency ?? getUserCurrency();
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currencyCode),
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Get currency symbol from code
  String _getCurrencySymbol(String code) {
    const symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'INR': '₹',
      'JPY': '¥',
      'CNY': '¥',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'CHF': 'CHF',
      'SEK': 'kr',
      'NZD': 'NZ\$',
    };
    return symbols[code] ?? code;
  }

  /// Format relative time (Today, Yesterday, X days ago, etc.)
  String formatRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays == 0) {
      // Same day - show time
      if (diff.inHours < 1) {
        if (diff.inMinutes < 1) {
          return 'Just now';
        }
        return '${diff.inMinutes}m ago';
      }
      return 'Today, ${DateFormat('h:mm a').format(timestamp)}';
    } else if (diff.inDays == 1) {
      return 'Yesterday, ${DateFormat('h:mm a').format(timestamp)}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(timestamp);
    }
  }

  /// Format activity subtitle based on type
  String formatActivitySubtitle(ActivityModel activity) {
    switch (activity.activityType) {
      case ActivityType.restaurant:
        final amount = formatAmount(
          activity.amountPerPerson ?? activity.amount ?? 0,
          currency: activity.currency,
        );
        final people = activity.participantCount ?? 0;
        return '$amount per person • $people people';

      case ActivityType.expense:
        final amount = formatAmount(
          activity.amount ?? 0,
          currency: activity.currency,
        );
        final paidBy = activity.paidBy ?? 'Someone';
        return '$amount • Paid by $paidBy';

      case ActivityType.settlement:
        final amount = formatAmount(
          activity.amount ?? 0,
          currency: activity.currency,
        );
        return 'You received $amount';

      default:
        return '';
    }
  }

  /// Get activity icon based on type
  IconData getActivityIcon(String activityType) {
    switch (activityType) {
      case ActivityType.restaurant:
        return Icons.restaurant;
      case ActivityType.expense:
        return Icons.receipt_long;
      case ActivityType.settlement:
        return Icons.account_balance_wallet;
      default:
        return Icons.swap_horiz;
    }
  }

  /// Get activity color based on type
  Color getActivityColor(String activityType) {
    switch (activityType) {
      case ActivityType.restaurant:
        return const Color(0xFF00B4D8);
      case ActivityType.expense:
        return const Color(0xFF0077B6);
      case ActivityType.settlement:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Navigation: Restaurant Split
  void navigateToRestaurantSplit(BuildContext context) {
    Navigator.of(context).pushNamed('/restaurant-split');
  }

  /// Navigation: Shared Living
  void navigateToSharedLiving(BuildContext context) {
    Navigator.of(context).pushNamed('/groups');
  }

  /// Navigation: Activity Detail
  void navigateToActivityDetail(BuildContext context, String activityId) {
    final activity = _activityService.getActivity(activityId);
    
    if (activity != null) {
      switch (activity.activityType) {
        case ActivityType.restaurant:
          Navigator.of(context).pushNamed(
            '/restaurant-detail',
            arguments: activityId,
          );
          break;
        case ActivityType.expense:
          if (activity.groupId != null) {
            Navigator.of(context).pushNamed(
              '/group-detail',
              arguments: activity.groupId,
            );
          }
          break;
        case ActivityType.settlement:
          Navigator.of(context).pushNamed(
            '/settlement-detail',
            arguments: activityId,
          );
          break;
      }
    }
  }

  /// Navigation: Settings
  void navigateToSettings(BuildContext context) {
    Navigator.of(context).pushNamed('/settings');
  }

  /// Navigation: View All Activities
  void navigateToAllActivities(BuildContext context) {
    Navigator.of(context).pushNamed('/all-activities');
  }

  /// Check if user has completed onboarding
  bool hasCompletedOnboarding() {
    return currentUser != null;
  }

  /// Get last restaurant split timestamp
  DateTime? getLastRestaurantSplitTime() {
    final restaurantActivities = recentActivities
        .where((a) => a.activityType == ActivityType.restaurant)
        .toList();
    
    if (restaurantActivities.isEmpty) return null;
    return restaurantActivities.first.timestamp;
  }

  /// Format last usage text
  String formatLastUsage(DateTime? timestamp) {
    if (timestamp == null) return 'Never used';
    
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inDays == 0) return 'Used today';
    if (diff.inDays == 1) return 'Used yesterday';
    if (diff.inDays < 7) return 'Last used ${diff.inDays} days ago';
    if (diff.inDays < 30) return 'Last used ${(diff.inDays / 7).floor()} weeks ago';
    return 'Last used ${DateFormat('MMM dd').format(timestamp)}';
  }
}
