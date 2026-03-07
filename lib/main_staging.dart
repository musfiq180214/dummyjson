import 'package:dummyjson/flavour_config.dart';

import 'core/utils/enums.dart';

import 'main.dart';
import 'core/constants/urls.dart';

void main() async {
  FlavorConfig.instantiate(
    flavor: Flavor.staging,
    baseUrl: baseUrlDevelopment,
    appTitle: 'DummJSON*Flutter App Staging',
  );
  await dummJSON();
}


/*
 valid user: {username: emilys, password: emilyspass}
 to generate translation: change intl_bn.arb and intl_en.arb and run: dart run intl_utils:generate
  to generate app icon and replace default app icon: 
  update directory of app icon in pubspec.yaml
  In Terminal:
  flutter pub run flutter_launcher_icons:main
  To RUN emulator first:
  flutter emulators --launch Pixel_5
  To RUN Staging:
  flutter run --flavor staging -t lib/main_staging.dart
  To Build Staging APK:
  flutter build apk --debug -t lib/main_staging.dart
*/