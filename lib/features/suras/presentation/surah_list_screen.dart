// lib/screens/surah_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quran_provider.dart';
import '../widgets/surah_card.dart';
import 'surah_detail_screen.dart';

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahAsync = ref.watch(surahListProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Holy Quran"),
      ),
      body: surahAsync.when(
        data: (surahs) {
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return SurahCard(
                surah: surah,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahDetailScreen(surah: surah),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text("Failed to load Surahs")),
      ),
    );
  }
}