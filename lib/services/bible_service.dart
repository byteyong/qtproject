// lib/services/bible_service.dart
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/bible_verse.dart'; //

class BibleService {
  static Future<Map<String, dynamic>> loadRandomChapter() async {
    try {
      // 1. 파일 전체 로드
      final String rawData =
          await rootBundle.loadString('assets/bible/bible.txt');
      final List<String> lines = rawData.split(RegExp(r'\r?\n'));

      final Map<String, List<BibleVerse>> chaptersMap = {};

      for (var line in lines) {
        final trimmed = line.trim();
        // 헤더(---)나 빈 줄은 무시
        if (trimmed.isEmpty || trimmed.startsWith('---')) continue;

        // "창1:1 <천지 창조> ..." 형식 파싱
        final firstSpace = trimmed.indexOf(' ');
        if (firstSpace == -1) continue;

        final reference = trimmed.substring(0, firstSpace); // "창1:1"
        final text = trimmed.substring(firstSpace + 1).trim(); // 본문 내용

        final refParts = reference.split(':'); // ["창1", "1"]
        if (refParts.length < 2) continue;

        final chapterKey = refParts[0]; // "창1"
        final verseNum = int.tryParse(refParts[1]) ?? 0;

        chaptersMap.putIfAbsent(chapterKey, () => []);
        chaptersMap[chapterKey]!.add(BibleVerse(
          verseNumber: verseNum,
          text: text,
        ));
      }

      // 2. 랜덤 선택
      final keys = chaptersMap.keys.toList();
      if (keys.isEmpty) throw Exception("성경 데이터를 찾을 수 없습니다.");

      final randomKey = keys[Random().nextInt(keys.length)];

      return {
        'title': _convertAbbreviation(randomKey),
        'verses': chaptersMap[randomKey],
      };
    } catch (e) {
      print("Bible Load Error: $e");
      rethrow;
    }
  }

  // "창1" -> "창세기 1장" 변환
  static String _convertAbbreviation(String key) {
    final abbrev = RegExp(r'[가-힣]+').stringMatch(key) ?? '';
    final chapter = RegExp(r'\d+').stringMatch(key) ?? '';

    const bookMap = {
      '창': '창세기',
      '출': '출애굽기',
      '레': '레위기',
      '민': '민수기',
      '신': '신명기',
      '수': '여호수아',
      '삿': '사사기',
      '룻': '룻기',
      '삼상': '사무엘상',
      '삼하': '사무엘하',
      '왕상': '열왕기상',
      '왕하': '열왕기하',
      '대상': '역대상',
      '대하': '역대하',
      '스': '에스라',
      '느': '느헤미야',
      '에': '에스더',
      '욥': '욥기',
      '시': '시편',
      '잠': '잠언',
      '전': '전도서',
      '아': '아가',
      '사': '이사야',
      '렘': '예레미야',
      '애': '예레미야애가',
      '겔': '에스겔',
      '단': '다니엘',
      '호': '호세아',
      '욜': '요엘',
      '암': '아모스',
      '옵': '오바댜',
      '요나': '요나',
      '미': '미가',
      '나': '나훔',
      '합': '하박국',
      '습': '스바냐',
      '학': '학개',
      '슥': '스가랴',
      '말': '말라기',
      '마': '마태복음',
      '막': '마가복음',
      '눅': '누가복음',
      '요': '요한복음',
      '행': '사도행전',
      '로': '로마서',
      '고전': '고린도전서',
      '고후': '고린도후서',
      '갈': '갈라디아서',
      '엡': '에베소서',
      '빌': '빌립보서',
      '골': '골로새서',
      '살전': '데살로니가전서',
      '살후': '데살로니가후서',
      '딤전': '디모데전서',
      '딤후': '디모데후서',
      '딛': '디도서',
      '몬': '빌레몬서',
      '히': '히브리서',
      '야': '야고보서',
      '벧전': '베드로전서',
      '벧후': '베드로후서',
      '요일': '요한일서',
      '요이': '요한이서',
      '요삼': '요한삼서',
      '유': '유다서',
      '계': '요한계시록'
    };

    return '${bookMap[abbrev] ?? abbrev} $chapter장';
  }
}
