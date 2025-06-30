import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUtils {
  /// Request storage permissions
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Request camera permissions
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Get application documents directory
  static Future<Directory> getAppDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Save file to application directory
  static Future<String> saveFileToAppDirectory(File file, String fileName) async {
    final appDir = await getAppDirectory();
    final savedFile = await file.copy('${appDir.path}/$fileName');
    return savedFile.path;
  }

  /// Get all saved panorama images
  static Future<List<FileSystemEntity>> getSavedPanoramaImages() async {
    final appDir = await getAppDirectory();
    final List<FileSystemEntity> files = appDir.listSync();
    return files.where((file) {
      return file.path.endsWith('.jpg') || 
             file.path.endsWith('.jpeg') || 
             file.path.endsWith('.png');
    }).toList();
  }
}