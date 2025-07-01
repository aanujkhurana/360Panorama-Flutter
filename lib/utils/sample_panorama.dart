
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SamplePanorama {
  /// Load a sample panorama image from the project folder
  static Future<String?> loadSamplePanorama() async {
    try {
      if (kIsWeb) {
        // For web, return the relative path to the sample image in the web/assets folder
        return 'assets/sample.jpg';
      } else {
        // For mobile platforms, use the sample.jpg in the project root
        final String samplePath = 'sample.jpg';
        final File sampleFile = File(samplePath);
        
        if (await sampleFile.exists()) {
          return sampleFile.path;
        } else {
          print('Sample panorama file not found at: ${sampleFile.path}');
          return null;
        }
      }
    } catch (e) {
      print('Error loading sample panorama: $e');
      return null;
    }
  }
}