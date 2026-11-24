#!/usr/bin/env bash
# MEMORA APK kurulum + derleme betiği (main_duzeltilmis.dart ile aynı klasörde çalıştır)
set -e
flutter create --org com.memora --project-name memora --platforms android memora_app
cp main_duzeltilmis.dart memora_app/lib/main.dart
cd memora_app
flutter pub add file_picker permission_handler shared_preferences
M=android/app/src/main/AndroidManifest.xml
sed -i 's#<application#<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>\n    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29"/>\n    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>\n    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>\n    <application android:requestLegacyExternalStorage="true"#' "$M"
sed -i 's#android:label="[^"]*"#android:label="MEMORA"#' "$M"
flutter build apk --release
echo "APK hazır: $(pwd)/build/app/outputs/flutter-apk/app-release.apk"
