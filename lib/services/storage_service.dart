import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../config/constants.dart';

/// Service for handling Firebase Storage operations
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Upload a profile photo for a member
  Future<String?> uploadProfilePhoto({
    required String memberId,
    required File imageFile,
  }) async {
    try {
      final ref = _storage
          .ref()
          .child(AppConstants.profilePhotosPath)
          .child('$memberId.jpg');

      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  /// Pick an image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Take a photo with camera
  Future<File?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a profile photo
  Future<void> deleteProfilePhoto(String memberId) async {
    try {
      final ref = _storage
          .ref()
          .child(AppConstants.profilePhotosPath)
          .child('$memberId.jpg');

      await ref.delete();
    } catch (e) {
      // Ignore if file doesn't exist
    }
  }

  /// Upload event image
  Future<String?> uploadEventImage({
    required String eventId,
    required File imageFile,
  }) async {
    try {
      final ref = _storage.ref().child('event_images').child('$eventId.jpg');

      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }
}
