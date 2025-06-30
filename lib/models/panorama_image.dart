import 'dart:io';

class PanoramaImage {
  final String id;
  final String path;
  final String name;
  final DateTime dateAdded;

  PanoramaImage({
    required this.id,
    required this.path,
    required this.name,
    required this.dateAdded,
  });

  File get file => File(path);

  bool get exists => file.existsSync();

  factory PanoramaImage.fromFile(File file) {
    return PanoramaImage(
      id: file.path.split('/').last,
      path: file.path,
      name: file.path.split('/').last,
      dateAdded: file.statSync().modified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
    };
  }

  factory PanoramaImage.fromMap(Map<String, dynamic> map) {
    return PanoramaImage(
      id: map['id'],
      path: map['path'],
      name: map['name'],
      dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded']),
    );
  }
}