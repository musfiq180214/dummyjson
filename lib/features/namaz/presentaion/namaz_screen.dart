import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/namaz_provider.dart';
import 'package:intl/intl.dart';

class NamazScreen extends ConsumerWidget {
  const NamazScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namazAsync = ref.watch(namazProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        elevation: 0,
        title: const Text("Prayer Times"),
        centerTitle: true,
      ),
      body: namazAsync.when(
        data: (namaz) {
          final prayers = {
            "Fajr": namaz.fajr,
            "Dhuhr": namaz.dhuhr,
            "Asr": namaz.asr,
            "Maghrib": namaz.maghrib,
            "Isha": namaz.isha,
          };

          final now = TimeOfDay.now();

          int nextPrayerIndex = _findNextPrayer(prayers.values.toList(), now);

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 📍 Location
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      namaz.district,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// 🌙 Next Prayer Banner
                _nextPrayerBanner(
                  prayers.keys.toList()[nextPrayerIndex],
                  prayers.values.toList()[nextPrayerIndex],
                ),

                const SizedBox(height: 25),

                /// 🕌 Prayer Cards
                Expanded(
                  child: ListView.builder(
                    itemCount: prayers.length,
                    itemBuilder: (context, index) {
                      final name = prayers.keys.toList()[index];
                      final time = prayers.values.toList()[index];

                      bool isNext = index == nextPrayerIndex;
                      bool isPast = index < nextPrayerIndex;

                      return prayerCard(
                        name,
                        time,
                        isNext,
                        isPast,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }

  /// Find next prayer
  int _findNextPrayer(List<String> times, TimeOfDay now) {
    for (int i = 0; i < times.length; i++) {
      final t = _parseTime(times[i]);

      if (_toMinutes(now) < _toMinutes(t)) {
        return i;
      }
    }
    return 0;
  }

  /// Convert HH:mm → TimeOfDay
  TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  int _toMinutes(TimeOfDay t) {
    return t.hour * 60 + t.minute;
  }
  String formatTo12Hour(String time) {
    final cleanTime = time.split(" ").first;

    final parts = cleanTime.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    final date = DateTime(2024, 1, 1, hour, minute);

    return DateFormat("hh:mm a").format(date);
  }

  /// Next prayer banner
  Widget _nextPrayerBanner(String name, String time) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff4CAF50), Color(0xff2E7D32)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Next Prayer",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            "$name • ${formatTo12Hour(time)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Prayer Card UI
  Widget prayerCard(
      String name,
      String time,
      bool isNext,
      bool isPast,
      ) {
    Color bgColor = Colors.white;
    Color textColor = Colors.black;

    if (isNext) {
      bgColor = const Color(0xffE8F5E9);
      textColor = Colors.green;
    }

    if (isPast) {
      bgColor = const Color(0xffEEEEEE);
      textColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          Text(
            formatTo12Hour(time),
            style: TextStyle(
              fontSize: 18,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}