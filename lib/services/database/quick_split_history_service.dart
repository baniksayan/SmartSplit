import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/restaurant/quick_split_model.dart';

/// Quick Split History Service
/// 
/// Manages storage and retrieval of quick split history using Hive.
/// Stores recent splits for quick access and reuse.
class QuickSplitHistoryService {
  static const String _boxName = 'quick_split_history';

  /// Get Hive box for quick splits
  Box<QuickSplitModel> _getBox() {
    return Hive.box<QuickSplitModel>(_boxName);
  }

  /// Initialize the box (call from main.dart)
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<QuickSplitModel>(_boxName);
    }
  }

  /// Save a split to history
  Future<void> saveSplit(QuickSplitModel split) async {
    try {
      final box = _getBox();
      await box.put(split.splitId, split);
      debugPrint('Quick split saved: ${split.splitId}');
    } catch (e) {
      debugPrint('Error saving quick split: $e');
      rethrow;
    }
  }

  /// Get recent splits sorted by timestamp (newest first)
  Future<List<QuickSplitModel>> getRecentSplits({int limit = 10}) async {
    try {
      final box = _getBox();
      final splits = box.values.toList();

      // Sort by timestamp (newest first)
      splits.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Return limited results
      return splits.take(limit).toList();
    } catch (e) {
      debugPrint('Error getting recent splits: $e');
      return [];
    }
  }

  /// Get all splits
  Future<List<QuickSplitModel>> getAllSplits() async {
    try {
      final box = _getBox();
      final splits = box.values.toList();
      splits.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return splits;
    } catch (e) {
      debugPrint('Error getting all splits: $e');
      return [];
    }
  }

  /// Get split by ID
  QuickSplitModel? getSplit(String splitId) {
    try {
      final box = _getBox();
      return box.get(splitId);
    } catch (e) {
      debugPrint('Error getting split: $e');
      return null;
    }
  }

  /// Update an existing split
  Future<void> updateSplit(QuickSplitModel split) async {
    try {
      final box = _getBox();
      await box.put(split.splitId, split);
      debugPrint('Quick split updated: ${split.splitId}');
    } catch (e) {
      debugPrint('Error updating split: $e');
      rethrow;
    }
  }

  /// Delete a split
  Future<void> deleteSplit(String splitId) async {
    try {
      final box = _getBox();
      await box.delete(splitId);
      debugPrint('Quick split deleted: $splitId');
    } catch (e) {
      debugPrint('Error deleting split: $e');
      rethrow;
    }
  }

  /// Check if any splits exist
  bool hasSplits() {
    try {
      final box = _getBox();
      return box.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking splits: $e');
      return false;
    }
  }

  /// Get total count of splits
  int getSplitCount() {
    try {
      final box = _getBox();
      return box.length;
    } catch (e) {
      debugPrint('Error getting split count: $e');
      return 0;
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      final box = _getBox();
      await box.clear();
      debugPrint('All quick split history cleared');
    } catch (e) {
      debugPrint('Error clearing history: $e');
      rethrow;
    }
  }

  /// Export splits to JSON
  Future<List<Map<String, dynamic>>> exportSplits() async {
    try {
      final splits = await getAllSplits();
      return splits.map((split) => split.toJson()).toList();
    } catch (e) {
      debugPrint('Error exporting splits: $e');
      return [];
    }
  }

  /// Import splits from JSON
  Future<void> importSplits(List<Map<String, dynamic>> jsonList) async {
    try {
      final box = _getBox();
      for (final json in jsonList) {
        final split = QuickSplitModel.fromJson(json);
        await box.put(split.splitId, split);
      }
      debugPrint('Imported ${jsonList.length} quick splits');
    } catch (e) {
      debugPrint('Error importing splits: $e');
      rethrow;
    }
  }

  /// Get splits by restaurant name
  Future<List<QuickSplitModel>> getSplitsByRestaurant(String restaurantName) async {
    try {
      final box = _getBox();
      final splits = box.values
          .where((split) =>
              split.restaurantName?.toLowerCase() == restaurantName.toLowerCase())
          .toList();
      splits.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return splits;
    } catch (e) {
      debugPrint('Error getting splits by restaurant: $e');
      return [];
    }
  }

  /// Get splits within date range
  Future<List<QuickSplitModel>> getSplitsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final box = _getBox();
      final splits = box.values
          .where((split) =>
              split.timestamp.isAfter(startDate) &&
              split.timestamp.isBefore(endDate))
          .toList();
      splits.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return splits;
    } catch (e) {
      debugPrint('Error getting splits by date range: $e');
      return [];
    }
  }

  /// Get total amount spent (all splits)
  double getTotalAmountSpent() {
    try {
      final box = _getBox();
      return box.values.fold(0.0, (sum, split) => sum + split.grandTotal);
    } catch (e) {
      debugPrint('Error calculating total amount: $e');
      return 0.0;
    }
  }

  /// Get average bill amount
  double getAverageBillAmount() {
    try {
      final box = _getBox();
      if (box.isEmpty) return 0.0;
      final total = box.values.fold(0.0, (sum, split) => sum + split.billAmount);
      return total / box.length;
    } catch (e) {
      debugPrint('Error calculating average: $e');
      return 0.0;
    }
  }
}
