import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Home Header Widget
/// 
/// Displays user profile picture, personalized greeting,
/// and settings navigation button.
class HomeHeader extends StatelessWidget {
  final String userName;
  final String greeting;
  final String? profilePicturePath;
  final VoidCallback onSettingsTap;

  const HomeHeader({
    Key? key,
    required this.userName,
    required this.greeting,
    this.profilePicturePath,
    required this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Profile Picture
            _buildProfilePicture(),
            const SizedBox(width: 16),

            // Greeting Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hi, $userName!',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Settings Button
            _buildSettingsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: profilePicturePath != null && profilePicturePath!.isNotEmpty
            ? Image.file(
                File(profilePicturePath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.white,
      child: Icon(
        Icons.person,
        size: 32,
        color: const Color(0xFF00B4D8),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSettingsTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
