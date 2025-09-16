Meal Management Flutter Starter

This is a Flutter starter project (Firebase-dependent) for Meal Management.
Important notes:
- You must add Firebase Android config file (google-services.json) into android/app/.
- To build APK you need a computer with Flutter SDK and Android SDK installed.

Build steps (on a PC/Mac with Flutter installed):
1. Place google-services.json into android/app/
2. flutter pub get
3. flutter build apk --release
4. APK will be at build/app/outputs/flutter-apk/app-release.apk

If you don't have a computer, you can use online CI services (Codemagic, GitHub Actions, etc.) to build the APK from this repo.
