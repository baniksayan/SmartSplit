import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../models/user/user_model.dart';
import '../../services/database/user_service.dart';
import '../../core/constants/currency_data.dart';
import '../../core/constants/language_data.dart';
import '../common/profile_image_picker.dart';
import '../common/currency_dropdown.dart';
import '../common/language_dropdown.dart';

/// Profile Setup Screen
/// First-time user profile creation
/// 
/// Features:
/// - Profile picture selection (optional)
/// - Name input (required)
/// - Email input (optional but validated)
/// - Currency selection (required, searchable)
/// - Language selection (required, searchable)
/// - Default split mode selection (required)
/// - Form validation
/// - Data persistence via Hive
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _profileImagePath;
  Currency _selectedCurrency = CurrencyData.popular[0]; // Default: INR
  Language _selectedLanguage = LanguageData.all[0]; // Default: English
  String _selectedSplitMode = SplitMode.equalSplit;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    // Image picker implementation will be handled by the actual image picker
    // For now, we'll show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera feature - coming soon')),
    );
  }

  Future<void> _pickImageFromGallery() async {
    // Image picker implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery feature - coming soon')),
    );
  }

  void _removeProfileImage() {
    setState(() {
      _profileImagePath = null;
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user model
      final user = UserModel(
        userId: const Uuid().v4(),
        userName: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        profilePicture: _profileImagePath,
        preferredCurrency: _selectedCurrency.code,
        preferredLanguage: _selectedLanguage.code,
        defaultSplitMode: _selectedSplitMode,
        createdAt: DateTime.now(),
      );

      // Save to Hive via UserService
      await UserService().saveUser(user);

      // Navigate to next screen (theme selection)
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/theme-selection');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Your Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Progress indicator
              _buildProgressIndicator(),
              const SizedBox(height: 32),

              // Profile picture
              Center(
                child: ProfileImagePicker(
                  imagePath: _profileImagePath,
                  onPickFromCamera: _pickImageFromCamera,
                  onPickFromGallery: _pickImageFromGallery,
                  onRemove: _profileImagePath != null ? _removeProfileImage : null,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Optional - Add a profile picture',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Name field
              _buildLabel('Name', required: true),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validateName,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),

              // Email field
              _buildLabel('Email', required: false),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email (optional)',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              // Currency selection
              _buildLabel('Preferred Currency', required: true),
              const SizedBox(height: 8),
              CurrencyDropdown(
                selectedCurrency: _selectedCurrency,
                onChanged: (currency) {
                  setState(() {
                    _selectedCurrency = currency;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Language selection
              _buildLabel('Preferred Language', required: true),
              const SizedBox(height: 8),
              LanguageDropdown(
                selectedLanguage: _selectedLanguage,
                onChanged: (language) {
                  setState(() {
                    _selectedLanguage = language;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Split mode selection
              _buildLabel('Default Split Mode', required: true),
              const SizedBox(height: 8),
              _buildSplitModeSelector(),
              const SizedBox(height: 32),

              // Continue button
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B4D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressDot(isActive: true, label: 'Profile'),
        _buildProgressLine(isActive: false),
        _buildProgressDot(isActive: false, label: 'Theme'),
        _buildProgressLine(isActive: false),
        _buildProgressDot(isActive: false, label: 'Done'),
      ],
    );
  }

  Widget _buildProgressDot({required bool isActive, required String label}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF00B4D8) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: isActive
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF00B4D8) : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isActive ? const Color(0xFF00B4D8) : Colors.grey[300],
      ),
    );
  }

  Widget _buildLabel(String text, {required bool required}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
      ],
    );
  }

  Widget _buildSplitModeSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: SplitMode.all.map((mode) {
          final isSelected = _selectedSplitMode == mode;
          final isLast = mode == SplitMode.all.last;

          return Column(
            children: [
              ListTile(
                title: Text(
                  mode,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  mode == SplitMode.equalSplit
                      ? 'Divide bill equally among all members'
                      : 'Split by individual items consumed',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                leading: Radio<String>(
                  value: mode,
                  groupValue: _selectedSplitMode,
                  onChanged: (value) {
                    setState(() {
                      _selectedSplitMode = value!;
                    });
                  },
                  activeColor: const Color(0xFF00B4D8),
                ),
                onTap: () {
                  setState(() {
                    _selectedSplitMode = mode;
                  });
                },
              ),
              if (!isLast)
                Divider(height: 1, color: Colors.grey[300]),
            ],
          );
        }).toList(),
      ),
    );
  }
}
