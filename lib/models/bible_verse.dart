import 'package:flutter/material.dart';

class BibleVerse {
  final int verseNumber;
  final String text;

  const BibleVerse({required this.verseNumber, required this.text});
}

class SharingPost {
  final int id;
  final String name;
  final String daysAgo;
  final String ref;
  final String verse;
  final String content;
  final String highlight;
  final int amen;

  const SharingPost({
    required this.id,
    required this.name,
    required this.daysAgo,
    required this.ref,
    required this.verse,
    required this.content,
    required this.highlight,
    required this.amen,
  });
}

// ── 더미 나눔 데이터 ────────────────────────────────────────────
const sharingData = [
  SharingPost(
    id: 1,
    name: '김지은',
    daysAgo: '2일 전',
    ref: '시편 23:1',
    verse: '여호와는 나의 목자시니 내게 부족함이 없으리로다',
    content: '오늘 하루도 주님께서 나의 목자가 되어주신다는 사실에 감사합니다. 아무것도 부족함이 없다는 확신 속에서...',
    highlight: '주님의 인도하심을 따르겠습니다',
    amen: 12,
  ),
  SharingPost(
    id: 2,
    name: '박성민',
    daysAgo: '3일 전',
    ref: '빌립보서 4:13',
    verse: '내게 능력 주시는 자 안에서 내가 모든 것을 할 수 있느니라',
    content: '오늘 어려운 프로젝트를 시작했는데, 이 말씀이 큰 힘이 되었습니다. 나의 힘이 아닌 주님의 능력으로...',
    highlight: '주님과 함께라면 두렵지 않아',
    amen: 8,
  ),
  SharingPost(
    id: 3,
    name: '이수진',
    daysAgo: '4일 전',
    ref: '요한복음 3:16',
    verse: '하나님이 세상을 이처럼 사랑하사 독생자를 주셨으니',
    content: '하나님의 사랑의 깊이를 다시 한번 묵상했습니다. 그 사랑이 너무 크고 깊어서 감사한 마음이 넘칩니다...',
    highlight: '그 사랑을 나누며 살겠습니다',
    amen: 21,
  ),
];

// ── 묵상 완료 날짜 (5월) ────────────────────────────────────────
const completedDays = [1, 3, 4, 6, 7, 8, 10, 12, 13, 14];

// lib/models/bible_verse.dart 맨 아래에 추가

class DrawingLine {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawingLine({
    required this.points,
    this.color = const Color(0xFF1DB87A), // 기본 색상은 주황/초록 테마에 맞춤
    this.strokeWidth = 3.0,
  });
}
