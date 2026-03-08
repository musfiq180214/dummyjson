// lib/screens/surah_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/surah_model.dart';
import '../providers/quran_provider.dart';

class SurahDetailScreen extends ConsumerWidget {
  final Surah surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahAsync = ref.watch(ayahListProvider(surah.number));

    return Scaffold(
      appBar: AppBar(
        title: Text(surah.englishName),
        centerTitle: true,
        backgroundColor: const Color(0xff0F5C4D),
      ),
      body: ayahAsync.when(
        data: (ayahs) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ayahs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final ayah = ayahs[index];
              return ListTile(
                title: Text(
                  ayah.text,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: ayah.translation.isNotEmpty
                    ? Text(
                  ayah.translation,
                  textAlign: TextAlign.left,
                  style:
                  const TextStyle(fontSize: 16, color: Colors.grey),
                )
                    : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text("Failed to load Surah: ${e.toString()}")),
      ),
    );
  }
}