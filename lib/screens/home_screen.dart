import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../widgets/panorama_viewer.dart';
import '../utils/sample_panorama.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.storage,
      Permission.camera,
    ].request();

    if (statuses[Permission.photos] != PermissionStatus.granted ||
        statuses[Permission.storage] != PermissionStatus.granted ||
        (statuses[Permission.camera] != PermissionStatus.granted)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissions are required to access images and camera'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Handle web platform differently
      if (kIsWeb) {
        setState(() {
          _isLoading = true;
        });
        
        try {
          final XFile? pickedFile = await _picker.pickImage(source: source);
          
          if (pickedFile != null) {
            setState(() {
              _isLoading = false;
            });
            
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PanoramaViewerWidget(
                    imagePath: pickedFile.path,
                  ),
                ),
              );
            }
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          
          String errorMessage = 'Error picking image';
          
          // Check for specific web platform errors
          if (e.toString().contains('unsupported')) {
            errorMessage = 'This feature is not fully supported in web browsers. Please try using the sample panorama or use a mobile device.';
          } else {
            errorMessage = 'Error picking image: $e';
          }
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
        return;
      }
      
      // Mobile platform handling
      await _requestPermissions();
      
      // Check specific permission based on source
      bool permissionGranted = false;
      if (source == ImageSource.camera) {
        permissionGranted = await Permission.camera.isGranted;
        if (!permissionGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Camera permission is required'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      } else {
        permissionGranted = await Permission.photos.isGranted;
        if (!permissionGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photos permission is required'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }
      
      setState(() {
        _isLoading = true;
      });

      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _isLoading = false;
        });

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PanoramaViewerWidget(
                imagePath: pickedFile.path,
              ),
            ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _loadSamplePanorama() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String? samplePath = await SamplePanorama.loadSamplePanorama();
      
      setState(() {
        _isLoading = false;
      });

      if (samplePath != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PanoramaViewerWidget(
              imagePath: samplePath,
            ),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sample panorama not available. Please select an image from gallery or camera.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading sample panorama: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('360° Panorama Viewer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
            tooltip: 'View History',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.panorama,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to 360° Panorama Viewer',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Select a panorama image from your gallery or take a new one with your camera',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Gallery'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: _loadSamplePanorama,
                        icon: const Icon(Icons.panorama_horizontal),
                        label: const Text('Try Sample Panorama'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}