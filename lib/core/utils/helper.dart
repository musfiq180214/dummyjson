import 'dart:developer';

import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

extension L10nExtension on BuildContext {
  S get t => S.of(this);
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isValidBDPhone(String value) {
  final bangladeshPhoneRegex = RegExp(r'^(?:\+8801|8801|01)[3-9]\d{8}$');
  return bangladeshPhoneRegex.hasMatch(value);
}

Map<String, dynamic> getNextPrayerDetailed(Map<String, String> timings) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  const mainPrayers = [
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Sunset',
    'Maghrib',
    'Isha',
    'NextDayFajr',
  ];

  final Map<String, DateTime> parsedTimes = {};

  for (final entry in timings.entries) {
    if (!mainPrayers.contains(entry.key)) continue;

    try {
      final timeStr = entry.value.trim().split(" ").first;
      final parts = timeStr.split(":");
      if (parts.length != 2) continue;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      DateTime dateTime = DateTime(
        today.year,
        today.month,
        today.day,
        hour,
        minute,
      );
      if (entry.key == 'NextDayFajr') {
        dateTime = dateTime.add(Duration(days: 1));
      }

      parsedTimes[entry.key] = dateTime;
    } catch (e) {
      debugPrint('⚠️ Error parsing ${entry.key}: ${entry.value} → $e');
    }
  }

  String currentPrayer = '';
  String nextPrayer = '';
  DateTime? currentPrayerTime;
  DateTime? nextPrayerTime;
  String? specialText;

  if (parsedTimes.isNotEmpty) {
    if (now.isBefore(parsedTimes["Fajr"]!)) {
      currentPrayer = "Isha";
      currentPrayerTime = parsedTimes["Isha"];
      nextPrayer = "Fajr";
      nextPrayerTime = parsedTimes["Fajr"];
    } else if (now.isBefore(parsedTimes["Sunrise"]!)) {
      currentPrayer = "Fajr";
      currentPrayerTime = parsedTimes["Fajr"];
      nextPrayer = "Sunrise";
      nextPrayerTime = parsedTimes["Sunrise"];
    } else if (now.isBefore(parsedTimes["Dhuhr"]!)) {
      currentPrayer = "";
      currentPrayerTime = null;
      nextPrayer = "Dhuhr";
      nextPrayerTime = parsedTimes["Dhuhr"];
      specialText = "No Fard Salat Till Dhuhr";
    } else if (now.isBefore(parsedTimes["Asr"]!)) {
      currentPrayer = "Dhuhr";
      currentPrayerTime = parsedTimes["Dhuhr"];
      nextPrayer = "Asr";
      nextPrayerTime = parsedTimes["Asr"];
    } else if (now.isBefore(parsedTimes["Maghrib"]!)) {
      currentPrayer = "Asr";
      currentPrayerTime = parsedTimes["Asr"];
      nextPrayer = "Maghrib";
      nextPrayerTime = parsedTimes["Maghrib"];
    } else if (now.isBefore(parsedTimes["Isha"]!)) {
      currentPrayer = "Maghrib";
      currentPrayerTime = parsedTimes["Maghrib"];
      nextPrayer = "Isha";
      nextPrayerTime = parsedTimes["Isha"];
    } else {
      currentPrayer = "Isha";
      currentPrayerTime = parsedTimes["Isha"];
      nextPrayer = "Fajr";
      nextPrayerTime = parsedTimes["NextDayFajr"];
    }
  }

  return {
    'currentPrayerName': currentPrayer,
    'currentPrayerTime': currentPrayerTime,
    'nextPrayerName': nextPrayer,
    'nextPrayerTime': nextPrayerTime,
    'specialText': specialText,
  };
}

String formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
}

String formatToAmPmManual(String time24h) {
  time24h = time24h.trim();

  final timeParts = time24h.split(":");

  if (timeParts.length != 2) {
    return "Invalid time";
  }

  final hour = int.tryParse(timeParts[0]) ?? 0;
  final minute = int.tryParse(timeParts[1]) ?? 0;

  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    return "Invalid time";
  }

  String period = (hour >= 12) ? "PM" : "AM";
  int displayHour = hour % 12;
  if (displayHour == 0) displayHour = 12;

  String formattedMinute = minute.toString().padLeft(2, "0");

  return "$displayHour:$formattedMinute$period";
}

void openMapWithCoordinates(double latitude, double longitude) async {
  final googleMapUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  final uri = Uri.parse(googleMapUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not open the map.';
  }
}

void openUrl(String url) async {
  final uri = Uri.tryParse(url)!;
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  } else {
    throw 'Could not open the url.';
  }
}

void makePhoneCall(String phoneNumber) async {
  log(phoneNumber);
  final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch dialer';
  }
}

String getLocalizedText({
  required BuildContext context,
  String? en,
  String? bn,
}) {
  final locale = Localizations.localeOf(context);
  return (locale.languageCode == 'bn' ? bn : en) ?? bn ?? en ?? '';
}

class PaginationState<T> {
  final List<T> data;
  final int currentPage;
  final bool isLoading;
  final bool hasMoreData;
  final String? error;

  PaginationState({
    required this.data,
    required this.currentPage,
    required this.isLoading,
    required this.hasMoreData,
    this.error,
  });

  PaginationState.initial()
    : data = [],
      currentPage = 1,
      isLoading = false,
      hasMoreData = true,
      error = null;

  PaginationState<T> copyWith({
    List<T>? data,
    int? currentPage,
    bool? isLoading,
    bool? hasMoreData,
    String? error,
  }) {
    return PaginationState<T>(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      error: error ?? this.error,
    );
  }
}

String formatDateTime(String isoDateString) {
  if (isoDateString.isNotEmpty) {
    DateTime dateTime = DateTime.tryParse(isoDateString)!.toLocal();
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }
  return "";
}

Future<bool> isUserInSaudiArabia() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location service is enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  // Check permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  // Get current location
  Position position = await Geolocator.getCurrentPosition();

  // Reverse geocode to get country
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isNotEmpty) {
    String? country = placemarks.first.country;
    return country?.toLowerCase().contains("saudi") ?? false;
  }

  return false;
}

String timeDifference(String isoStart, String isoEnd) {
  try {
    DateTime start = DateTime.tryParse(isoStart)!;
    DateTime end = DateTime.tryParse(isoEnd)!;

    Duration diff = end.difference(start);

    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;

    return '${hours}h ${minutes}m';
  } catch (e) {
    AppLogger.e(e.toString());
    return "";
  }
}

class NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Remove leading zeros
    int leadingZeros =
        text.length - text.replaceFirst(RegExp(r'^0+'), '').length;
    text = text.replaceFirst(RegExp(r'^0+'), '');

    // Enforce max length of 10 digits
    if (text.length > 10) text = text.substring(0, 10);

    // Adjust cursor
    int offset = newValue.selection.baseOffset - leadingZeros;
    offset = offset.clamp(0, text.length);

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // Check permission status
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Location permissions are permanently denied, we cannot request.',
    );
  }

  // Get the current position
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

class DownloadState {
  final double progress;
  final bool isDownloading;
  final bool isCompleted;
  final String? error;

  const DownloadState({
    this.progress = 0.0,
    this.isDownloading = false,
    this.isCompleted = false,
    this.error,
  });

  DownloadState copyWith({
    double? progress,
    bool? isDownloading,
    bool? isCompleted,
    String? error,
  }) {
    return DownloadState(
      progress: progress ?? this.progress,
      isDownloading: isDownloading ?? this.isDownloading,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error,
    );
  }
}

Future<XFile?> getCompressedImage(XFile file, {double maxSizeInMb = 1}) async {
  int quality = 100; // start from max quality
  XFile? compressedFile = file;
  int fileSize = await file.length();

  while (fileSize / (1024 * 1024) > maxSizeInMb && quality > 10) {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(
      dir.path,
      'temp_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: quality,
    );

    if (compressedFile == null) break;

    fileSize = await compressedFile.length();
    quality -= 10; // decrease quality gradually
  }

  return compressedFile;
}
