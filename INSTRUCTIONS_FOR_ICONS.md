# Instructions for App Icon Generation

The application icon has been configured using the `flutter_launcher_icons` package.
The source image is located at `assets/images/app_icon.jpg`.

## Steps to Generate Icons

Since the Flutter SDK was not available in the development environment, the final generation step must be run manually.

1.  Ensure you have Flutter installed and set up.
2.  Run the following commands in the project root:

```bash
flutter pub get
dart run flutter_launcher_icons
```

This will generate the launcher icons for both Android and iOS platforms, placing them in the correct directories (`android/app/src/main/res` and `ios/Runner/Assets.xcassets`).
