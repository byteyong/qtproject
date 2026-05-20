import 'package:flutter/material.dart';
import '../../../models/bible_verse.dart';
import 'app_colors.dart';

class BibleVerseList extends StatelessWidget {
  final String chapterTitle;
  final List<BibleVerse> verses;
  final bool showSwipeHint;

  const BibleVerseList({
    super.key,
    required this.chapterTitle,
    required this.verses,
    this.showSwipeHint = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      itemCount: verses.length + (showSwipeHint ? 2 : 1), // +title +hint
      itemBuilder: (ctx, i) {
        // 첫 번째: 챕터 제목
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              chapterTitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 0.8,
              ),
            ),
          );
        }
        // 마지막: 스와이프 힌트
        if (showSwipeHint && i == verses.length + 1) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chevron_right,
                    size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(
                  '스와이프하여 묵상 보기',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          );
        }
        // 성경 구절
        final verse = verses[i - 1];
        return _VerseRow(verse: verse);
      },
    );
  }
}

class _VerseRow extends StatelessWidget {
  final BibleVerse verse;
  const _VerseRow({required this.verse});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${verse.verseNumber}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              verse.text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.85,
                color: AppColors.textDark,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
