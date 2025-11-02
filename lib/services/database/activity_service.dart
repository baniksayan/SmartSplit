import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/activity/activity_model.dart';

/// Activity Service
/// 
/// Manages activity data persistence using Hive.
/// Handles CRUD operations for recent activity feed.
class ActivityService {
  static const String _boxName = 'activity_data';

  /// Get Hive box for activities
  Box<ActivityModel> _getActivityBox() {
    return Hive.box<ActivityModel>(_boxName);
  }

  /// Initialize the activity box (call from main.dart)
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<ActivityModel>(_boxName);
    }
  }

  /// Get recent activities sorted by timestamp (newest first)
  /// 
  /// [limit] - Maximum number of activities to return (default: 5)
  Future<List<ActivityModel>> getRecentActivities({int limit = 5}) async {
    try {
      final box = _getActivityBox();
      final activities = box.values.toList();

      // Sort by timestamp (newest first)
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Return limited results
      return activities.take(limit).toList();
    } catch (e) {
      debugPrint('Error getting recent activities: $e');
      return [];
    }
  }

  /// Get all activities sorted by timestamp
  Future<List<ActivityModel>> getAllActivities() async {
    try {
      final box = _getActivityBox();
      final activities = box.values.toList();
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return activities;
    } catch (e) {
      debugPrint('Error getting all activities: $e');
      return [];
    }
  }

  /// Add a new activity
  Future<void> addActivity(ActivityModel activity) async {
    try {
      final box = _getActivityBox();
      await box.put(activity.activityId, activity);

      // Cleanup old activities if needed
      await cleanupOldActivities();
    } catch (e) {
      debugPrint('Error adding activity: $e');
      rethrow;
    }
  }

  /// Get activity by ID
  ActivityModel? getActivity(String activityId) {
    try {
      final box = _getActivityBox();
      return box.get(activityId);
    } catch (e) {
      debugPrint('Error getting activity: $e');
      return null;
    }
  }

  /// Update an existing activity
  Future<void> updateActivity(ActivityModel activity) async {
    try {
      final box = _getActivityBox();
      await box.put(activity.activityId, activity);
    } catch (e) {
      debugPrint('Error updating activity: $e');
      rethrow;
    }
  }

  /// Delete an activity
  Future<void> deleteActivity(String activityId) async {
    try {
      final box = _getActivityBox();
      await box.delete(activityId);
    } catch (e) {
      debugPrint('Error deleting activity: $e');
      rethrow;
    }
  }

  /// Get activities by type
  Future<List<ActivityModel>> getActivitiesByType(String activityType) async {
    try {
      final box = _getActivityBox();
      final activities = box.values
          .where((activity) => activity.activityType == activityType)
          .toList();
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return activities;
    } catch (e) {
      debugPrint('Error getting activities by type: $e');
      return [];
    }
  }

  /// Get activities for a specific group
  Future<List<ActivityModel>> getGroupActivities(String groupId) async {
    try {
      final box = _getActivityBox();
      final activities = box.values
          .where((activity) => activity.groupId == groupId)
          .toList();
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return activities;
    } catch (e) {
      debugPrint('Error getting group activities: $e');
      return [];
    }
  }

  /// Clean up old activities (keep last 50)
  /// This prevents the database from growing too large
  Future<void> cleanupOldActivities() async {
    try {
      final box = _getActivityBox();

      if (box.length > 50) {
        final activities = box.values.toList();
        activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        // Get activities to delete (everything after first 50)
        final toDelete = activities.skip(50).map((a) => a.activityId).toList();

        // Delete old activities
        await box.deleteAll(toDelete);

        debugPrint('Cleaned up ${toDelete.length} old activities');
      }
    } catch (e) {
      debugPrint('Error cleaning up old activities: $e');
    }
  }

  /// Check if any activities exist
  bool hasActivities() {
    try {
      final box = _getActivityBox();
      return box.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking activities: $e');
      return false;
    }
  }

  /// Get total count of activities
  int getActivityCount() {
    try {
      final box = _getActivityBox();
      return box.length;
    } catch (e) {
      debugPrint('Error getting activity count: $e');
      return 0;
    }
  }

  /// Clear all activities (for testing/debugging)
  Future<void> clearAll() async {
    try {
      final box = _getActivityBox();
      await box.clear();
      debugPrint('All activities cleared');
    } catch (e) {
      debugPrint('Error clearing activities: $e');
      rethrow;
    }
  }

  /// Export activities to JSON
  Future<List<Map<String, dynamic>>> exportActivities() async {
    try {
      final activities = await getAllActivities();
      return activities.map((activity) => activity.toJson()).toList();
    } catch (e) {
      debugPrint('Error exporting activities: $e');
      return [];
    }
  }

  /// Import activities from JSON
  Future<void> importActivities(List<Map<String, dynamic>> jsonList) async {
    try {
      final box = _getActivityBox();
      for (final json in jsonList) {
        final activity = ActivityModel.fromJson(json);
        await box.put(activity.activityId, activity);
      }
      debugPrint('Imported ${jsonList.length} activities');
    } catch (e) {
      debugPrint('Error importing activities: $e');
      rethrow;
    }
  }
}
