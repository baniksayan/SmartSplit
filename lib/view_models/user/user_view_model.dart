import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../models/user/user_model.dart';
import '../../services/database/user_service.dart';
import '../../core/constants/currency_data.dart';
import '../../core/constants/language_data.dart';

/// UserViewModel - MVVM ViewModel for managing user state
/// 
/// Handles:
/// - Form validation
/// - Profile image selection
/// - User data management
/// - State updates
class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // User data
  UserModel? _currentUser;
  String? _profileImagePath;
  Currency _selectedCurrency = CurrencyData.popular[0]; // Default: INR
  Language _selectedLanguage = LanguageData.all[0]; // Default: English
  String _selectedSplitMode = SplitMode.equalSplit;
  String _selectedTheme = AppThemeMode.light;
  String _selectedFontSize = FontSizeOption.medium;

  // Custom theme colors
  Color? _customPrimaryColor;
  Color? _customSecondaryColor;
  Color? _customAccentColor;

  // Loading and validation states
  bool _isLoading = false;
  String? _nameError;
  String? _emailError;

  // Getters
  UserModel? get currentUser => _currentUser;
  String? get profileImagePath => _profileImagePath;
  Currency get selectedCurrency => _selectedCurrency;
  Language get selectedLanguage => _selectedLanguage;
  String get selectedSplitMode => _selectedSplitMode;
  String get selectedTheme => _selectedTheme;
  String get selectedFontSize => _selectedFontSize;
  Color? get customPrimaryColor => _customPrimaryColor;
  Color? get customSecondaryColor => _customSecondaryColor;
  Color? get customAccentColor => _customAccentColor;
  bool get isLoading => _isLoading;
  String? get nameError => _nameError;
  String? get emailError => _emailError;

  /// Initialize ViewModel
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _userService.getCurrentUser();
    
    if (_currentUser != null) {
      // Load existing user data
      nameController.text = _currentUser!.userName;
      emailController.text = _currentUser!.email ?? '';
      _profileImagePath = _currentUser!.profilePicture;
      _selectedCurrency = CurrencyData.findByCode(_currentUser!.preferredCurrency) ?? CurrencyData.popular[0];
      _selectedLanguage = LanguageData.findByCode(_currentUser!.preferredLanguage) ?? LanguageData.all[0];
      _selectedSplitMode = _currentUser!.defaultSplitMode;
      _selectedTheme = _currentUser!.themeMode ?? AppThemeMode.light;
      _selectedFontSize = _currentUser!.fontSize ?? FontSizeOption.medium;

      // Load custom colors if theme is custom
      if (_selectedTheme == AppThemeMode.custom) {
        if (_currentUser!.customPrimaryColor != null) {
          _customPrimaryColor = _colorFromHex(_currentUser!.customPrimaryColor!);
        }
        if (_currentUser!.customSecondaryColor != null) {
          _customSecondaryColor = _colorFromHex(_currentUser!.customSecondaryColor!);
        }
        if (_currentUser!.customAccentColor != null) {
          _customAccentColor = _colorFromHex(_currentUser!.customAccentColor!);
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Set currency
  void setCurrency(Currency currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  /// Set language
  void setLanguage(Language language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  /// Set split mode
  void setSplitMode(String mode) {
    _selectedSplitMode = mode;
    notifyListeners();
  }

  /// Set theme
  void setTheme(String theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  /// Set font size
  void setFontSize(String size) {
    _selectedFontSize = size;
    notifyListeners();
  }

  /// Set custom colors
  void setCustomColors({Color? primary, Color? secondary, Color? accent}) {
    if (primary != null) _customPrimaryColor = primary;
    if (secondary != null) _customSecondaryColor = secondary;
    if (accent != null) _customAccentColor = accent;
    notifyListeners();
  }

  /// Pick profile image from camera
  Future<bool> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        _profileImagePath = image.path;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return false;
    }
  }

  /// Pick profile image from gallery
  Future<bool> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        _profileImagePath = image.path;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return false;
    }
  }

  /// Remove profile image
  void removeProfileImage() {
    _profileImagePath = null;
    notifyListeners();
  }

  /// Validate name
  bool validateName() {
    final name = nameController.text.trim();
    
    if (name.isEmpty) {
      _nameError = 'Name is required';
      notifyListeners();
      return false;
    }

    if (name.length < 2) {
      _nameError = 'Name must be at least 2 characters';
      notifyListeners();
      return false;
    }

    if (name.length > 50) {
      _nameError = 'Name must be less than 50 characters';
      notifyListeners();
      return false;
    }

    _nameError = null;
    notifyListeners();
    return true;
  }

  /// Validate email
  bool validateEmail() {
    final email = emailController.text.trim();

    // Email is optional
    if (email.isEmpty) {
      _emailError = null;
      notifyListeners();
      return true;
    }

    // Regex for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      _emailError = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    _emailError = null;
    notifyListeners();
    return true;
  }

  /// Validate all fields
  bool validateAll() {
    final nameValid = validateName();
    final emailValid = validateEmail();
    return nameValid && emailValid;
  }

  /// Save user profile
  Future<bool> saveProfile() async {
    if (!validateAll()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final user = UserModel(
        userId: _currentUser?.userId ?? const Uuid().v4(),
        userName: nameController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        profilePicture: _profileImagePath,
        preferredCurrency: _selectedCurrency.code,
        preferredLanguage: _selectedLanguage.code,
        defaultSplitMode: _selectedSplitMode,
        createdAt: _currentUser?.createdAt ?? DateTime.now(),
        themeMode: _selectedTheme,
        customPrimaryColor: _customPrimaryColor != null ? _colorToHex(_customPrimaryColor!) : null,
        customSecondaryColor: _customSecondaryColor != null ? _colorToHex(_customSecondaryColor!) : null,
        customAccentColor: _customAccentColor != null ? _colorToHex(_customAccentColor!) : null,
        fontSize: _selectedFontSize,
      );

      await _userService.saveUser(user);
      _currentUser = user;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving profile: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Color to hex string
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Hex string to color
  Color _colorFromHex(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
