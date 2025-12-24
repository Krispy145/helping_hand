import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/ui.dart';

class ProfileAvatar extends StatefulWidget {
  final double radius;
  final bool editable;

  static const String prefKey = 'profile_image_path';

  const ProfileAvatar({super.key, this.radius = 40, this.editable = false});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(ProfileAvatar.prefKey);
    if (path != null) {
      final file = File(path);
      // ignore: avoid_slow_async_io
      if (await file.exists()) {
        setState(() {
          _imageFile = file;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    // Basic permission check (more robust logic can be added)
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) return;
    } else {
      // Android 13+ might need photos permission, using image_picker usually handles this well automatically
      // or returns specific error. For MVP we rely on plugin.
    }

    try {
      final pickedFile = await _picker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final newPath = '${directory.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final newImage = await File(pickedFile.path).copy(newPath);

        setState(() {
          _imageFile = newImage;
        });

        // Persist path
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(ProfileAvatar.prefKey, newPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to set image: $e')));
      }
    }
  }

  void _showSourceSelector() {
    if (!widget.editable) return;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSourceSelector,
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: context.surface,
        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
        child: _imageFile == null ? Icon(Icons.person, size: widget.radius, color: context.textSecondary) : null,
      ),
    );
  }
}
