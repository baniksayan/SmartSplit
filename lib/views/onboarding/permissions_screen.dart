import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permissions Screen
/// 
/// Requests necessary permissions:
/// - Camera (for bill photos)
/// - Storage (for exporting files)
/// - Notifications (for settlement reminders)
/// 
/// Each permission has Allow and Skip options
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _cameraGranted = false;
  bool _storageGranted = false;
  bool _notificationsGranted = false;
  bool _isLoading = false;

  final List<PermissionItem> _permissions = [
    PermissionItem(
      title: 'Camera Access',
      description: 'Take photos of bills and receipts for easy expense tracking',
      icon: Icons.camera_alt,
      color: const Color(0xFF00B4D8),
    ),
    PermissionItem(
      title: 'Storage Access',
      description: 'Save and export expense reports to your device',
      icon: Icons.folder,
      color: const Color(0xFF0077B6),
    ),
    PermissionItem(
      title: 'Notifications',
      description: 'Get reminders for pending settlements and updates',
      icon: Icons.notifications,
      color: const Color(0xFF90E0EF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final storageStatus = await Permission.storage.status;
    final notificationStatus = await Permission.notification.status;

    setState(() {
      _cameraGranted = cameraStatus.isGranted;
      _storageGranted = storageStatus.isGranted;
      _notificationsGranted = notificationStatus.isGranted;
    });
  }

  Future<void> _requestAllPermissions() async {
    setState(() {
      _isLoading = true;
    });

    // Request camera permission
    if (!_cameraGranted) {
      final status = await Permission.camera.request();
      _cameraGranted = status.isGranted;
    }

    // Request storage permission
    if (!_storageGranted) {
      final status = await Permission.storage.request();
      _storageGranted = status.isGranted;
    }

    // Request notification permission
    if (!_notificationsGranted) {
      final status = await Permission.notification.request();
      _notificationsGranted = status.isGranted;
    }

    setState(() {
      _isLoading = false;
    });

    // If all granted or user decided, go to home
    if (_cameraGranted && _storageGranted && _notificationsGranted) {
      _completeOnboarding();
    }
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    
    setState(() {
      if (permission == Permission.camera) {
        _cameraGranted = status.isGranted;
      } else if (permission == Permission.storage) {
        _storageGranted = status.isGranted;
      } else if (permission == Permission.notification) {
        _notificationsGranted = status.isGranted;
      }
    });
  }

  void _skipPermissions() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // Mark onboarding as complete
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final allGranted = _cameraGranted && _storageGranted && _notificationsGranted;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'App Permissions',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: _skipPermissions,
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Progress indicator
                  _buildProgressIndicator(),
                  const SizedBox(height: 32),

                  // Info text
                  Text(
                    'To provide you the best experience, SmartSplit needs a few permissions.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Permission cards
                  _buildPermissionCard(
                    _permissions[0],
                    _cameraGranted,
                    () => _requestPermission(Permission.camera),
                  ),
                  const SizedBox(height: 16),
                  _buildPermissionCard(
                    _permissions[1],
                    _storageGranted,
                    () => _requestPermission(Permission.storage),
                  ),
                  const SizedBox(height: 16),
                  _buildPermissionCard(
                    _permissions[2],
                    _notificationsGranted,
                    () => _requestPermission(Permission.notification),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Allow all button
                  if (!allGranted)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _requestAllPermissions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B4D8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Allow All Permissions',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                  // Continue button (if all granted)
                  if (allGranted)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _completeOnboarding,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Continue to App',
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
        _buildProgressDot(isActive: true, isCompleted: true, label: 'Theme'),
        _buildProgressLine(isActive: true),
        _buildProgressDot(isActive: true, isCompleted: false, label: 'Done'),
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

  Widget _buildPermissionCard(
    PermissionItem item,
    bool isGranted,
    VoidCallback onRequest,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGranted ? Colors.green : Colors.grey[300]!,
          width: isGranted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isGranted)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Granted',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          if (!isGranted) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onRequest,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: item.color),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Allow',
                  style: GoogleFonts.poppins(
                    color: item.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Permission Item Model
class PermissionItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  PermissionItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
