import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// User Model for SmartSplit
/// Stores user profile information and preferences
/// 
/// Uses Hive for local persistence with TypeAdapter
@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? profilePicture;

  @HiveField(4)
  final String preferredCurrency;

  @HiveField(5)
  final String preferredLanguage;

  @HiveField(6)
  final String defaultSplitMode;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final String? themeMode;

  @HiveField(9)
  final String? customPrimaryColor;

  @HiveField(10)
  final String? customSecondaryColor;

  @HiveField(11)
  final String? customAccentColor;

  @HiveField(12)
  final String? fontSize;

  UserModel({
    required this.userId,
    required this.userName,
    this.email,
    this.profilePicture,
    required this.preferredCurrency,
    required this.preferredLanguage,
    required this.defaultSplitMode,
    required this.createdAt,
    this.themeMode,
    this.customPrimaryColor,
    this.customSecondaryColor,
    this.customAccentColor,
    this.fontSize,
  });

  /// Create a copy with updated fields
  UserModel copyWith({
    String? userId,
    String? userName,
    String? email,
    String? profilePicture,
    String? preferredCurrency,
    String? preferredLanguage,
    String? defaultSplitMode,
    DateTime? createdAt,
    String? themeMode,
    String? customPrimaryColor,
    String? customSecondaryColor,
    String? customAccentColor,
    String? fontSize,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      defaultSplitMode: defaultSplitMode ?? this.defaultSplitMode,
      createdAt: createdAt ?? this.createdAt,
      themeMode: themeMode ?? this.themeMode,
      customPrimaryColor: customPrimaryColor ?? this.customPrimaryColor,
      customSecondaryColor: customSecondaryColor ?? this.customSecondaryColor,
      customAccentColor: customAccentColor ?? this.customAccentColor,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  /// Convert to JSON for export/backup
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'profilePicture': profilePicture,
      'preferredCurrency': preferredCurrency,
      'preferredLanguage': preferredLanguage,
      'defaultSplitMode': defaultSplitMode,
      'createdAt': createdAt.toIso8601String(),
      'themeMode': themeMode,
      'customPrimaryColor': customPrimaryColor,
      'customSecondaryColor': customSecondaryColor,
      'customAccentColor': customAccentColor,
      'fontSize': fontSize,
    };
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String?,
      profilePicture: json['profilePicture'] as String?,
      preferredCurrency: json['preferredCurrency'] as String,
      preferredLanguage: json['preferredLanguage'] as String,
      defaultSplitMode: json['defaultSplitMode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      themeMode: json['themeMode'] as String?,
      customPrimaryColor: json['customPrimaryColor'] as String?,
      customSecondaryColor: json['customSecondaryColor'] as String?,
      customAccentColor: json['customAccentColor'] as String?,
      fontSize: json['fontSize'] as String?,
    );
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, userName: $userName, email: $email, currency: $preferredCurrency, language: $preferredLanguage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}

/// Split Mode Constants
class SplitMode {
  static const String equalSplit = 'Equal Split';
  static const String itemLevel = 'Item-Level Split';

  static List<String> get all => [equalSplit, itemLevel];
}

/// Font Size Constants
class FontSizeOption {
  static const String small = 'Small';
  static const String medium = 'Medium';
  static const String large = 'Large';
  static const String extraLarge = 'Extra Large';

  static List<String> get all => [small, medium, large, extraLarge];

  static double getSize(String option) {
    switch (option) {
      case small:
        return 0.85;
      case medium:
        return 1.0;
      case large:
        return 1.15;
      case extraLarge:
        return 1.3;
      default:
        return 1.0;
    }
  }
}

/// Theme Mode Constants
class AppThemeMode {
  static const String light = 'Light';
  static const String dark = 'Dark';
  static const String blueOcean = 'Blue Ocean';
  static const String forest = 'Forest';
  static const String sunsetOrange = 'Sunset Orange';
  static const String custom = 'Custom';

  static List<String> get predefined => [
        light,
        dark,
        blueOcean,
        forest,
        sunsetOrange,
      ];

  static List<String> get all => [...predefined, custom];
}
