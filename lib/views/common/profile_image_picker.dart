import 'dart:io';
import 'package:flutter/material.dart';

/// Profile Image Picker Widget
/// Allows selecting image from camera or gallery
/// Shows circular preview
class ProfileImagePicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPickFromCamera;
  final VoidCallback onPickFromGallery;
  final VoidCallback? onRemove;
  final double size;

  const ProfileImagePicker({
    Key? key,
    this.imagePath,
    required this.onPickFromCamera,
    required this.onPickFromGallery,
    this.onRemove,
    this.size = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showImageSourceDialog(context),
          child: Stack(
            children: [
              // Profile image circle
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                  image: imagePath != null
                      ? DecorationImage(
                          image: FileImage(File(imagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imagePath == null
                    ? Icon(
                        Icons.person,
                        size: size * 0.5,
                        color: Colors.grey[400],
                      )
                    : null,
              ),
              // Camera icon badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (imagePath != null && onRemove != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRemove,
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Remove'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ],
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  onPickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  onPickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
