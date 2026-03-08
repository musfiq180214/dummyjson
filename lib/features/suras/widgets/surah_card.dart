import 'package:flutter/material.dart';
import '../domain/surah_model.dart';

class SurahCard extends StatelessWidget {

  final Surah surah;
  final VoidCallback onTap;

  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0,4),
          )
        ],
      ),

      child: ListTile(

        onTap: onTap,

        leading: CircleAvatar(
          backgroundColor: const Color(0xff0F5C4D),
          child: Text(
            surah.number.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),

        title: Text(
          surah.englishName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text("${surah.ayahs} Ayahs"),

        trailing: Text(
          surah.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}