import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _profileService = ProfileService();
  final _imagePicker = ImagePicker();
  bool _isUploading = false;
  String? _profilePhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
  }

  Future<void> _loadProfilePhoto() async {
    setState(() {
      _profilePhotoUrl = _profileService.getProfilePhotoUrl();
    });
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.borderColor, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_a_photo, size: 48, color: AppTheme.primaryColor),
              const SizedBox(height: 16),
              Text('Choose Photo Source', style: AppTheme.dialogTitle),
              const SizedBox(height: 24),
              _buildDialogButton(
                text: 'CAMERA',
                icon: Icons.camera_alt,
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 12),
              _buildDialogButton(
                text: 'GALLERY',
                icon: Icons.photo_library,
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                color: AppTheme.accentColor,
              ),
              if (_profilePhotoUrl != null) ...[
                const SizedBox(height: 12),
                _buildDialogButton(
                  text: 'REMOVE PHOTO',
                  icon: Icons.delete,
                  onPressed: () {
                    Navigator.pop(context);
                    _removeProfilePhoto();
                  },
                  color: AppTheme.poorAttendance,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() => _isUploading = true);

      // Pass XFile directly to service
      final photoUrl = await _profileService.uploadProfilePhoto(image);

      setState(() {
        _profilePhotoUrl = photoUrl;
        _isUploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile photo updated!', style: AppTheme.attendanceText),
            backgroundColor: AppTheme.accentColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload photo: $e', style: AppTheme.attendanceText),
            backgroundColor: AppTheme.poorAttendance,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _removeProfilePhoto() async {
    try {
      setState(() => _isUploading = true);

      await _profileService.deleteProfilePhoto();

      setState(() {
        _profilePhotoUrl = null;
        _isUploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile photo removed', style: AppTheme.attendanceText),
            backgroundColor: AppTheme.accentColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove photo: $e', style: AppTheme.attendanceText),
            backgroundColor: AppTheme.poorAttendance,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.borderColor, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, size: 48, color: AppTheme.primaryColor),
              const SizedBox(height: 16),
              Text('Logout', style: AppTheme.dialogTitle),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to logout?',
                style: AppTheme.attendanceText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialogButton(
                    text: 'CANCEL',
                    onPressed: () => Navigator.pop(context),
                    color: Colors.grey.shade300,
                  ),
                  _buildDialogButton(
                    text: 'LOGOUT',
                    onPressed: () async {
                      await _authService.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                    color: AppTheme.poorAttendance,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.borderColor,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: AppTheme.buttonText.copyWith(
                    fontSize: 14,
                    color: color == Colors.grey.shade300 ? AppTheme.textColor : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User info card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.borderColor,
                    offset: const Offset(6, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile photo with tap to change
                  GestureDetector(
                    onTap: _isUploading ? null : _showImageSourceDialog,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.borderColor, width: 3),
                          ),
                          child: _isUploading
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primaryColor,
                                    strokeWidth: 3,
                                  ),
                                )
                              : _profilePhotoUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        _profilePhotoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.person,
                                            size: 48,
                                            color: AppTheme.primaryColor,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 48,
                                      color: AppTheme.primaryColor,
                                    ),
                        ),
                        // Camera icon overlay
                        if (!_isUploading)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.borderColor, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.email ?? 'No email',
                    style: AppTheme.subjectName.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderColor, width: 2),
                    ),
                    child: Text(
                      'Active',
                      style: AppTheme.labelText.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Logout button
            Container(
              decoration: BoxDecoration(
                color: AppTheme.poorAttendance,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.borderColor,
                    offset: const Offset(6, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleLogout(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'LOGOUT',
                          style: AppTheme.buttonText.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
