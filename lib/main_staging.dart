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
