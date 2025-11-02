import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user/user_model.dart';

/// UserService - Manages user data persistence using Hive
/// 
/// Handles:
/// - Saving and loading user profiles
/// - Managing first-launch state
/// - CRUD operations for user data
class UserService {
  static const String _userBoxName = 'user_data';
  static const String _currentUserKey = 'current_user';

  /// Get the user box
  Future<Box<UserModel>> _getUserBox() async {
    if (!Hive.isBoxOpen(_userBoxName)) {
      return await Hive.openBox<UserModel>(_userBoxName);
    }
    return Hive.box<UserModel>(_userBoxName);
  }

  /// Save user profile
  Future<void> saveUser(UserModel user) async {
    final box = await _getUserBox();
    await box.put(_currentUserKey, user);
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    final box = await _getUserBox();
    return box.get(_currentUserKey);
  }

  /// Update user profile
  Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  /// Delete user profile
  Future<void> deleteUser() async {
    final box = await _getUserBox();
    await box.delete(_currentUserKey);
  }

  /// Check if user profile exists
  Future<bool> hasUser() async {
    final box = await _getUserBox();
    return box.containsKey(_currentUserKey);
  }

  /// Update user field
  Future<void> updateUserField(String field, dynamic value) async {
    final user = await getCurrentUser();
    if (user == null) return;

    UserModel updatedUser = user;

    switch (field) {
      case 'userName':
        updatedUser = user.copyWith(userName: value as String);
        break;
      case 'email':
        updatedUser = user.copyWith(email: value as String?);
        break;
      case 'profilePicture':
        updatedUser = user.copyWith(profilePicture: value as String?);
        break;
      case 'preferredCurrency':
        updatedUser = user.copyWith(preferredCurrency: value as String);
        break;
      case 'preferredLanguage':
        updatedUser = user.copyWith(preferredLanguage: value as String);
        break;
      case 'defaultSplitMode':
        updatedUser = user.copyWith(defaultSplitMode: value as String);
        break;
      case 'themeMode':
        updatedUser = user.copyWith(themeMode: value as String?);
        break;
      case 'customPrimaryColor':
        updatedUser = user.copyWith(customPrimaryColor: value as String?);
        break;
      case 'customSecondaryColor':
        updatedUser = user.copyWith(customSecondaryColor: value as String?);
        break;
      case 'customAccentColor':
        updatedUser = user.copyWith(customAccentColor: value as String?);
        break;
      case 'fontSize':
        updatedUser = user.copyWith(fontSize: value as String?);
        break;
    }

    await saveUser(updatedUser);
  }

  /// Export user data as JSON
  Future<Map<String, dynamic>?> exportUserData() async {
    final user = await getCurrentUser();
    return user?.toJson();
  }

  /// Import user data from JSON
  Future<void> importUserData(Map<String, dynamic> json) async {
    final user = UserModel.fromJson(json);
    await saveUser(user);
  }

  /// Clear all user data
  Future<void> clearAll() async {
    final box = await _getUserBox();
    await box.clear();
  }
}
