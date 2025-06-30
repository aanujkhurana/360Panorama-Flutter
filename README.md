# 360° Panorama Viewer

A Flutter application that allows users to view 360-degree panoramic images. The app provides an immersive experience for exploring panoramic photos with intuitive controls for navigation.

## Features

- View 360° panoramic images with interactive controls
- Take panoramic photos using the device camera
- Select existing panoramic images from the gallery
- Zoom in/out and navigate within panoramic views
- View image viewing history
- Display coordinates (longitude, latitude) and zoom level
- Toggle control panel visibility

## Getting Started

### Prerequisites

- Flutter SDK (latest version recommended)
- Android Studio or VS Code with Flutter extensions
- iOS/Android device or emulator

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

```bash
git clone <repository-url>
cd panorama_viewer
flutter pub get
flutter run
```

## Dependencies

- [panorama](https://pub.dev/packages/panorama): For rendering 360° panoramic images
- [image_picker](https://pub.dev/packages/image_picker): For selecting images from gallery or camera
- [path_provider](https://pub.dev/packages/path_provider): For file system access
- [permission_handler](https://pub.dev/packages/permission_handler): For handling device permissions

## Usage

1. Launch the app
2. Choose to take a new panoramic photo or select one from your gallery
3. Use touch gestures to navigate the panoramic view:
   - Swipe to rotate the view
   - Pinch to zoom in/out
4. Use the control panel at the bottom to:
   - Adjust zoom level
   - Navigate left/right/up/down
   - Reset the view
5. Toggle the control panel visibility using the eye icon in the app bar
6. View your panorama viewing history by tapping the history icon

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- The panorama package developers for providing the core 360° viewing functionality
- Flutter team for the amazing cross-platform framework
