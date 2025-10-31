import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// Image Service
/// Handles photo capture and upload for verified impact

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Take photo with camera
  static Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (photo == null) return null;
      return File(photo.path);
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  /// Pick image from gallery
  static Future<File?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Pick multiple images
  static Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      print('Error picking multiple images: $e');
      return [];
    }
  }

  /// Show option dialog to choose camera or gallery
  static Future<File?> showImageSourceDialog() async {
    // TODO: Show dialog in UI
    // For now, default to camera
    return await takePhoto();
  }
}
