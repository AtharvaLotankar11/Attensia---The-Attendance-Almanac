import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user ID
  String? get _userId => _supabase.auth.currentUser?.id;

  // Upload profile photo to Supabase Storage (works on all platforms)
  Future<String> uploadProfilePhoto(XFile imageFile) async {
    if (_userId == null) throw Exception('User not authenticated');

    final fileName = '$_userId-${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storagePath = 'profile_photos/$fileName';

    // Read file as bytes (works on web and mobile)
    final bytes = await imageFile.readAsBytes();

    // Upload to Supabase Storage
    await _supabase.storage.from('avatars').uploadBinary(
          storagePath,
          bytes,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );

    // Get public URL
    final publicUrl = _supabase.storage.from('avatars').getPublicUrl(storagePath);

    // Update user metadata with photo URL
    await _supabase.auth.updateUser(
      UserAttributes(
        data: {'avatar_url': publicUrl},
      ),
    );

    return publicUrl;
  }

  // Get current user's profile photo URL
  String? getProfilePhotoUrl() {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final metadata = user.userMetadata;
    return metadata?['avatar_url'] as String?;
  }

  // Delete profile photo
  Future<void> deleteProfilePhoto() async {
    if (_userId == null) throw Exception('User not authenticated');

    final photoUrl = getProfilePhotoUrl();
    if (photoUrl == null) return;

    // Extract file path from URL
    final uri = Uri.parse(photoUrl);
    final pathSegments = uri.pathSegments;
    if (pathSegments.length >= 2) {
      final filePath = pathSegments.sublist(pathSegments.length - 2).join('/');

      // Delete from storage
      await _supabase.storage.from('avatars').remove([filePath]);
    }

    // Remove from user metadata
    await _supabase.auth.updateUser(
      UserAttributes(
        data: {'avatar_url': null},
      ),
    );
  }
}
