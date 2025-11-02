import 'package:hive/hive.dart';

part 'activity_model.g.dart';

/// Activity Model
/// 
/// Represents a user activity in SmartSplit app.
/// Activities can be:
/// - Restaurant splits
/// - Shared living expenses
/// - Settlements
/// 
/// Stored in Hive for offline access and recent activity feed.
@HiveType(typeId: 1)
class ActivityModel {
  /// Unique identifier for the activity
  @HiveField(0)
  final String activityId;

  /// Type of activity: "restaurant", "expense", "settlement"
  @HiveField(1)
  final String activityType;

  /// Timestamp when activity was created
  @HiveField(2)
  final DateTime timestamp;

  /// Title of the activity (e.g., "Dinner with friends")
  @HiveField(3)
  final String title;

  /// Optional description/notes
  @HiveField(4)
  final String? description;

  /// Amount involved (for expenses and settlements)
  @HiveField(5)
  final double? amount;

  /// Number of participants (for restaurant splits)
  @HiveField(6)
  final int? participantCount;

  /// Associated group ID (for shared living activities)
  @HiveField(7)
  final String? groupId;

  /// Group name (for display purposes)
  @HiveField(8)
  final String? groupName;

  /// User who made the payment
  @HiveField(9)
  final String? paidBy;

  /// Amount per person (for restaurant splits)
  @HiveField(10)
  final double? amountPerPerson;

  /// Currency code (USD, EUR, INR, etc.)
  @HiveField(11)
  final String? currency;

  ActivityModel({
    required this.activityId,
    required this.activityType,
    required this.timestamp,
    required this.title,
    this.description,
    this.amount,
    this.participantCount,
    this.groupId,
    this.groupName,
    this.paidBy,
    this.amountPerPerson,
    this.currency,
  });

  /// Create a copy of this activity with updated fields
  ActivityModel copyWith({
    String? activityId,
    String? activityType,
    DateTime? timestamp,
    String? title,
    String? description,
    double? amount,
    int? participantCount,
    String? groupId,
    String? groupName,
    String? paidBy,
    double? amountPerPerson,
    String? currency,
  }) {
    return ActivityModel(
      activityId: activityId ?? this.activityId,
      activityType: activityType ?? this.activityType,
      timestamp: timestamp ?? this.timestamp,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      participantCount: participantCount ?? this.participantCount,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      paidBy: paidBy ?? this.paidBy,
      amountPerPerson: amountPerPerson ?? this.amountPerPerson,
      currency: currency ?? this.currency,
    );
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'activityType': activityType,
      'timestamp': timestamp.toIso8601String(),
      'title': title,
      'description': description,
      'amount': amount,
      'participantCount': participantCount,
      'groupId': groupId,
      'groupName': groupName,
      'paidBy': paidBy,
      'amountPerPerson': amountPerPerson,
      'currency': currency,
    };
  }

  /// Create from JSON
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activityId: json['activityId'] as String,
      activityType: json['activityType'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      title: json['title'] as String,
      description: json['description'] as String?,
      amount: json['amount'] as double?,
      participantCount: json['participantCount'] as int?,
      groupId: json['groupId'] as String?,
      groupName: json['groupName'] as String?,
      paidBy: json['paidBy'] as String?,
      amountPerPerson: json['amountPerPerson'] as double?,
      currency: json['currency'] as String?,
    );
  }

  @override
  String toString() {
    return 'ActivityModel(id: $activityId, type: $activityType, title: $title, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityModel && other.activityId == activityId;
  }

  @override
  int get hashCode => activityId.hashCode;
}

/// Activity Type Constants
class ActivityType {
  static const String restaurant = 'restaurant';
  static const String expense = 'expense';
  static const String settlement = 'settlement';

  static List<String> get all => [restaurant, expense, settlement];

  static bool isValid(String type) => all.contains(type);
}
