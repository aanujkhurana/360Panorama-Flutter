import 'dart:io';
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PanoramaViewerWidget extends StatefulWidget {
  final String imagePath;

  const PanoramaViewerWidget({super.key, required this.imagePath});

  @override
  State<PanoramaViewerWidget> createState() => _PanoramaViewerWidgetState();
}

class _PanoramaViewerWidgetState extends State<PanoramaViewerWidget> {
  double _lon = 0;
  double _lat = 0;
  double _zoom = 1.0;
  bool _showControls = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('360° Panorama View'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showControls ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _showControls = !_showControls;
              });
            },
            tooltip: _showControls ? 'Hide Controls' : 'Show Controls',
          ),
        ],
      ),
      body: Stack(
        children: [
          Panorama(
            longitude: _lon,
            latitude: _lat,
            zoom: _zoom,
            sensitivity: 3.0,
            animSpeed: 0.5,
            onViewChanged: (longitude, latitude, tilt) {
              setState(() {
                _lon = longitude;
                _lat = latitude;
              });
            },
            child: kIsWeb
                ? Image.network(widget.imagePath)
                : Image.file(File(widget.imagePath)),
          ),
          if (_showControls)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Zoom'),
                      Slider(
                        value: _zoom,
                        min: 1.0,
                        max: 5.0,
                        divisions: 40,
                        label: '${_zoom.toStringAsFixed(1)}x',
                        onChanged: (value) {
                          setState(() {
                            _zoom = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildControlButton(
                            icon: Icons.rotate_left,
                            onPressed: () {
                              setState(() {
                                _lon -= 10;
                              });
                            },
                            tooltip: 'Rotate Left',
                          ),
                          _buildControlButton(
                            icon: Icons.rotate_right,
                            onPressed: () {
                              setState(() {
                                _lon += 10;
                              });
                            },
                            tooltip: 'Rotate Right',
                          ),
                          _buildControlButton(
                            icon: Icons.arrow_upward,
                            onPressed: () {
                              setState(() {
                                _lat = (_lat - 10).clamp(-90.0, 90.0);
                              });
                            },
                            tooltip: 'Look Up',
                          ),
                          _buildControlButton(
                            icon: Icons.arrow_downward,
                            onPressed: () {
                              setState(() {
                                _lat = (_lat + 10).clamp(-90.0, 90.0);
                              });
                            },
                            tooltip: 'Look Down',
                          ),
                          _buildControlButton(
                            icon: Icons.refresh,
                            onPressed: () {
                              setState(() {
                                _lon = 0;
                                _lat = 0;
                                _zoom = 1.0;
                              });
                            },
                            tooltip: 'Reset View',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Longitude: ${_lon.toStringAsFixed(1)}°',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Latitude: ${_lat.toStringAsFixed(1)}°',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Zoom: ${_zoom.toStringAsFixed(1)}x',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
        ),
        child: Icon(icon),
      ),
    );
  }
}