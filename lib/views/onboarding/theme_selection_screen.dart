import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../models/user/user_model.dart';
import '../../services/database/user_service.dart';

/// Theme Selection Screen
/// 
/// Features:
/// - 5 predefined themes (Light, Dark, Blue Ocean, Forest, Sunset Orange)
/// - Custom theme with color picker
/// - Font size selection (Small, Medium, Large, Extra Large)
/// - Live theme preview
/// - Skip option
/// - Save and continue
class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  String _selectedTheme = AppThemeMode.light;
  String _selectedFontSize = FontSizeOption.medium;
  
  // Custom theme colors
  Color _customPrimaryColor = const Color(0xFF00B4D8);
  Color _customSecondaryColor = const Color(0xFF0077B6);
  Color _customAccentColor = const Color(0xFF90E0EF);

  final Map<String, ThemeColors> _predefinedThemes = {
    AppThemeMode.light: ThemeColors(
      primary: const Color(0xFF00B4D8),
      secondary: const Color(0xFF0077B6),
      accent: const Color(0xFF90E0EF),
      background: Colors.white,
    ),
    AppThemeMode.dark: ThemeColors(
      primary: const Color(0xFF90E0EF),
      secondary: const Color(0xFF00B4D8),
      accent: const Color(0xFF0077B6),
      background: const Color(0xFF121212),
    ),
    AppThemeMode.blueOcean: ThemeColors(
      primary: const Color(0xFF006494),
      secondary: const Color(0xFF0582CA),
      accent: const Color(0xFF00A6FB),
      background: const Color(0xFFF0F8FF),
    ),
    AppThemeMode.forest: ThemeColors(
      primary: const Color(0xFF2D6A4F),
      secondary: const Color(0xFF40916C),
      accent: const Color(0xFF52B788),
      background: const Color(0xFFF1FAEE),
    ),
    AppThemeMode.sunsetOrange: ThemeColors(
      primary: const Color(0xFFE63946),
      secondary: const Color(0xFFF77F00),
      accent: const Color(0xFFFCAB10),
      background: const Color(0xFFFFF8F0),
    ),
  };

  void _skipToPermissions() {
    Navigator.of(context).pushReplacementNamed('/permissions');
  }

  Future<void> _saveAndContinue() async {
    try {
      // Get current user and update theme preferences
      final userService = UserService();
      final user = await userService.getCurrentUser();
      
      if (user != null) {
        final updatedUser = user.copyWith(
          themeMode: _selectedTheme,
          fontSize: _selectedFontSize,
          customPrimaryColor: _selectedTheme == AppThemeMode.custom
              ? _colorToHex(_customPrimaryColor)
              : null,
          customSecondaryColor: _selectedTheme == AppThemeMode.custom
              ? _colorToHex(_customSecondaryColor)
              : null,
          customAccentColor: _selectedTheme == AppThemeMode.custom
              ? _colorToHex(_customAccentColor)
              : null,
        );
        
        await userService.updateUser(updatedUser);
      }
      
      // Navigate to permissions screen
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/permissions');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving theme: $e')),
        );
      }
    }
  }
  
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  void _showColorPicker(String colorType) {
    Color pickerColor = _customPrimaryColor;
    
    if (colorType == 'primary') {
      pickerColor = _customPrimaryColor;
    } else if (colorType == 'secondary') {
      pickerColor = _customSecondaryColor;
    } else {
      pickerColor = _customAccentColor;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick ${colorType.toUpperCase()} Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) {
              setState(() {
                if (colorType == 'primary') {
                  _customPrimaryColor = color;
                } else if (colorType == 'secondary') {
                  _customSecondaryColor = color;
                } else {
                  _customAccentColor = color;
                }
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = _selectedTheme == AppThemeMode.custom
        ? ThemeColors(
            primary: _customPrimaryColor,
            secondary: _customSecondaryColor,
            accent: _customAccentColor,
            background: Colors.white,
          )
        : _predefinedThemes[_selectedTheme]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customize Theme',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: _skipToPermissions,
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            const SizedBox(height: 32),

            // Theme preview
            _buildThemePreview(currentTheme),
            const SizedBox(height: 32),

            // Theme selection
            _buildLabel('Choose Theme'),
            const SizedBox(height: 12),
            _buildThemeSelector(),
            const SizedBox(height: 24),

            // Custom theme colors (only if custom selected)
            if (_selectedTheme == AppThemeMode.custom) ...[
              _buildLabel('Custom Colors'),
              const SizedBox(height: 12),
              _buildCustomColorPickers(),
              const SizedBox(height: 24),
            ],

            // Font size selection
            _buildLabel('Font Size'),
            const SizedBox(height: 12),
            _buildFontSizeSelector(),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _saveAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save & Continue',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressDot(isActive: true, isCompleted: true, label: 'Profile'),
        _buildProgressLine(isActive: true),
        _buildProgressDot(isActive: true, isCompleted: false, label: 'Theme'),
        _buildProgressLine(isActive: false),
        _buildProgressDot(isActive: false, isCompleted: false, label: 'Done'),
      ],
    );
  }

  Widget _buildProgressDot({
    required bool isActive,
    required bool isCompleted,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : isActive
                    ? const Color(0xFF00B4D8)
                    : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : (isActive ? Icons.circle : null),
            color: Colors.white,
            size: isActive ? 12 : 18,
          ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildThemePreview(ThemeColors theme) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Preview app bar
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.white),
                const SizedBox(width: 16),
                Text(
                  'Preview',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Preview content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sample Text',
                    style: GoogleFonts.poppins(
                      fontSize: 16 * FontSizeOption.getSize(_selectedFontSize),
                      fontWeight: FontWeight.w600,
                      color: theme.background == Colors.white
                          ? Colors.black87
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: theme.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'Preview Card',
                          style: GoogleFonts.poppins(
                            fontSize:
                                14 * FontSizeOption.getSize(_selectedFontSize),
                            color: theme.background == Colors.white
                                ? Colors.black87
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [...AppThemeMode.predefined, AppThemeMode.custom].map((theme) {
        final isSelected = _selectedTheme == theme;
        final themeColors = theme == AppThemeMode.custom
            ? ThemeColors(
                primary: _customPrimaryColor,
                secondary: _customSecondaryColor,
                accent: _customAccentColor,
                background: Colors.white,
              )
            : _predefinedThemes[theme]!;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTheme = theme;
            });
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? themeColors.primary : Colors.grey[300]!,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: themeColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: themeColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  theme,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomColorPickers() {
    return Column(
      children: [
        _buildColorPickerRow('Primary', _customPrimaryColor, 'primary'),
        const SizedBox(height: 12),
        _buildColorPickerRow('Secondary', _customSecondaryColor, 'secondary'),
        const SizedBox(height: 12),
        _buildColorPickerRow('Accent', _customAccentColor, 'accent'),
      ],
    );
  }

  Widget _buildColorPickerRow(String label, Color color, String type) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        GestureDetector(
          onTap: () => _showColorPicker(type),
          child: Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFontSizeSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: FontSizeOption.all.map((size) {
          final isSelected = _selectedFontSize == size;
          final isLast = size == FontSizeOption.all.last;

          return Column(
            children: [
              ListTile(
                title: Text(
                  size,
                  style: TextStyle(
                    fontSize: 16 * FontSizeOption.getSize(size),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                leading: Radio<String>(
                  value: size,
                  groupValue: _selectedFontSize,
                  onChanged: (value) {
                    setState(() {
                      _selectedFontSize = value!;
                    });
                  },
                  activeColor: const Color(0xFF00B4D8),
                ),
                onTap: () {
                  setState(() {
                    _selectedFontSize = size;
                  });
                },
              ),
              if (!isLast) Divider(height: 1, color: Colors.grey[300]),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Theme Colors Model
class ThemeColors {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;

  ThemeColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
  });
}
