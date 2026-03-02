import 'package:dummyjson/flavour_config.dart';
import 'package:dummyjson/main.dart';

import 'core/utils/enums.dart';

import 'core/constants/urls.dart';

void main() async {
  FlavorConfig.instantiate(
    flavor: Flavor.production,
    baseUrl: baseUrlProduction,
    appTitle: 'DummJSON*Flutter App Delivery',
  );
  await dummJSON();
}
