import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  static const String settingsBox = 'settings';
  static const String cartBox = 'cart';
  static const String ordersBox = 'orders';
  static const String locationBox = 'location';

  // Keys
  static const String keyInitialLocation = 'initial_location';
  static const String keySelectedLanguage = 'selected_language';
  static const String keySelectedDistrict = 'selected_district';
  static const String keySelectedThana = 'selected_thana';
  static const String keySelectedArea = 'selected_area';
  static const String keySelectedAreaBn = 'selected_area_bn';
  static const String keySelectedAreaId = 'selected_area_id';
  static const String keyIsOnboardingComplete = 'is_onboarding_complete';

  /// Save data to a specific box
  Future<void> saveData<T>(String boxName, String key, T value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  /// Get data from a specific box
  T? getData<T>(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.get(key) as T?;
  }

  /// Delete data from a specific box
  Future<void> deleteData(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  /// Clear all data in a box
  Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  // Language Helpers
  Future<void> saveLanguage(String languageCode) async {
    await saveData(settingsBox, keySelectedLanguage, languageCode);
  }

  String? getLanguage() {
    return getData<String>(settingsBox, keySelectedLanguage);
  }

  // Onboarding Helpers
  Future<void> setOnboardingComplete(bool complete) async {
    await saveData(settingsBox, keyIsOnboardingComplete, complete);
  }

  bool isOnboardingComplete() {
    return getData<bool>(settingsBox, keyIsOnboardingComplete) ?? false;
  }

  // Location Selection Helpers
  Future<void> saveLocationSelection({
    required String district,
    required String thana,
    required String area,
    String? areaBn,
    int? areaId,
  }) async {
    await saveData(locationBox, keySelectedDistrict, district);
    await saveData(locationBox, keySelectedThana, thana);
    await saveData(locationBox, keySelectedArea, area);
    if (areaBn != null) {
      await saveData(locationBox, keySelectedAreaBn, areaBn);
    }
    if (areaId != null) {
      await saveData(locationBox, keySelectedAreaId, areaId);
    }
  }

  Map<String, dynamic> getLocationSelection() {
    return {
      'district': getData<String>(locationBox, keySelectedDistrict),
      'thana': getData<String>(locationBox, keySelectedThana),
      'area': getData<String>(locationBox, keySelectedArea),
      'area_bn': getData<String>(locationBox, keySelectedAreaBn),
      'area_id': getData<int>(locationBox, keySelectedAreaId),
    };
  }

  int? getSelectedAreaId() {
    return getData<int>(locationBox, keySelectedAreaId);
  }

  // Location Helpers
  Future<void> saveInitialLocation(String location) async {
    await saveData(locationBox, keyInitialLocation, location);
  }

  String? getInitialLocation() {
    return getData<String>(locationBox, keyInitialLocation);
  }

  // Generic Cart Caching (Storing as JSON/Map)
  Future<void> cacheCart(Map<String, dynamic> cartJson) async {
    await saveData(cartBox, 'current_cart', cartJson);
  }

  Map<String, dynamic>? getCachedCart() {
    final data = getData(cartBox, 'current_cart');
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  // Generic Orders Caching
  Future<void> cacheOrders(List<Map<String, dynamic>> ordersJson) async {
    await saveData(ordersBox, 'recent_orders', ordersJson);
  }

  List<Map<String, dynamic>>? getCachedOrders() {
    final data = getData(ordersBox, 'recent_orders');
    if (data == null) return null;
    return (data as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
