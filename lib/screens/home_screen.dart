import 'package:flutter/material.dart';
import '../../../models/bible_verse.dart';
import '../../../services/bible_service.dart';
import '../../../services/ai_service.dart';
import '../../../widgets/app_colors.dart';
import '../../../widgets/qt_question_card.dart';
import '../../../widgets/meditation_card.dart';
import '../../../widgets/bible_verse_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BibleVerse> _verses = [];
  String _chapterTitle = '';
  List<String> _questions = [
    '하나님의 사랑이 내 삶에서 어떻게 나타나고 있나요?',
    '영생을 얻는다는 것이 오늘 내게 어떤 의미인가요?',
    '이 말씀을 통해 누군가에게 전하고 싶은 것은 무엇인가요?',
  ];
  bool _loadingQ = false;
  String _meditation = '';
  final _meditationCtrl = TextEditingController();

  // 모바일 슬라이드 페이지
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadRandomBible(); // 앱 시작 시 랜덤으로 불러오기
    _meditationCtrl.addListener(() {
      setState(() => _meditation = _meditationCtrl.text);
    });
  }

  // 기존 _loadBible을 대체하는 새로운 함수
  Future<void> _loadRandomBible() async {
    // BibleService에서 랜덤 장 데이터를 가져옵니다.
    final result = await BibleService.loadRandomChapter();

    if (mounted) {
      setState(() {
        _verses = result['verses'];
        _chapterTitle = result['title'];
        // 새로운 본문이 로드되면 이전 묵상 질문과 내용은 초기화하는 것이 좋습니다.
        _meditationCtrl.clear();
        _questions = [
          '말씀을 읽으며 가장 마음에 와닿는 단어나 문구는 무엇인가요?',
          '오늘의 말씀이 나의 상황에 어떤 메시지를 주나요?',
          '이 말씀을 통해 새롭게 깨달은 하나님은 어떤 분이신가요?',
        ];
      });
    }
  }

  @override
  void dispose() {
    _meditationCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _generateQuestions() async {
    setState(() => _loadingQ = true);
    final verseTexts = _verses.map((v) => v.text).toList();
    final q = await AiService.generateQTQuestions(
      chapterTitle: _chapterTitle,
      verseTexts: verseTexts,
    );
    if (mounted) {
      setState(() {
        _questions = q;
        _loadingQ = false;
      });
    }
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 1024;

    if (isMobile) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  // ══════════════════════════════════════════════════════════════
  // 데스크톱: 좌우 분할
  // ══════════════════════════════════════════════════════════════
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // 왼쪽: 성경 본문 (flex: 1)
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: BibleVerseList(
              chapterTitle: _chapterTitle,
              verses: _verses,
            ),
          ),
        ),
        // 오른쪽: QT 카드들 (flex: 1로 설정하여 1:1 비율 구현)
        Expanded(
          flex: 1,
          child: Container(
            color: AppColors.bg,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                QTQuestionCard(
                  questions: _questions,
                  isLoading: _loadingQ,
                  onRegenerate: _generateQuestions,
                ),
                const SizedBox(height: 20),
                // MeditationCard가 남은 높이를 채우도록 Expanded 사용
                Expanded(
                  child: MeditationCard(
                    controller: _meditationCtrl,
                    meditation: _meditation,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 모바일: 슬라이드 (PageView) - 오버플로우 패치 완료
  // ══════════════════════════════════════════════════════════════
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // ── 탭 헤더 ──
        _buildTabHeader(),
        // ── 슬라이드 영역 ──
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (p) => setState(() => _currentPage = p),
            children: [
              // 페이지 0: 말씀 (자체 내부 스크롤뷰 내장)
              BibleVerseList(
                chapterTitle: _chapterTitle,
                verses: _verses,
                showSwipeHint: true,
              ),
              // 페이지 1: 묵상 탭 (키보드 대응 외부 스크롤 및 카드 높이 한계 지정)
              Container(
                color: AppColors.bg,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      QTQuestionCard(
                        questions: _questions,
                        isLoading: _loadingQ,
                        onRegenerate: _generateQuestions,
                        compact: true,
                      ),
                      const SizedBox(height: 14),
                      // MeditationCard 내부의 텍스트가 격리되어 스크롤되도록 고정된 크기 제약 한계선 지정
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 240, // 내용이 없을 때 카드 기본 최소 높이
                          maxHeight: 340, // 키보드가 올라와도 화면 전체를 해치지 않는 최대 한계 높이
                        ),
                        child: MeditationCard(
                          controller: _meditationCtrl,
                          meditation: _meditation,
                          compact: true,
                        ),
                      ),
                      // 키보드가 활성화되었을 때 입력창 하단이 잘리거나 가려지는 현상 보완용 간격 패딩 추가
                      SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom > 0
                              ? 30
                              : 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // ── 하단 네비게이션 바 ──
        _buildBottomNav(),
      ],
    );
  }

  Widget _buildTabHeader() {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TabItem(
            icon: Icons.menu_book_outlined,
            label: '말씀',
            isSelected: _currentPage == 0,
            onTap: () => _goToPage(0),
          ),
          _TabItem(
            icon: Icons.chat_bubble_outline,
            label: '묵상',
            isSelected: _currentPage == 1,
            onTap: () => _goToPage(1),
          ),
          const Spacer(),
          // 도트 인디케이터
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: List.generate(2, (i) {
                final active = _currentPage == i;
                return GestureDetector(
                  onTap: () => _goToPage(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.primaryMid,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽: 말씀
          _NavPill(
            icon: Icons.chevron_left,
            label: '말씀',
            iconOnLeft: true,
            isActive: _currentPage == 0,
            onTap: () => _goToPage(0),
          ),
          // 도트
          Row(
            children: List.generate(2, (i) {
              final active = _currentPage == i;
              return GestureDetector(
                onTap: () => _goToPage(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.primaryMid,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          // 오른쪽: 묵상
          _NavPill(
            icon: Icons.chevron_right,
            label: '묵상',
            iconOnLeft: false,
            isActive: _currentPage == 1,
            onTap: () => _goToPage(1),
          ),
        ],
      ),
    );
  }
}

// ── 탭 아이템 ─────────────────────────────────────────────────
class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 하단 내비 pill ────────────────────────────────────────────
class _NavPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool iconOnLeft;
  final bool isActive;
  final VoidCallback onTap;

  const _NavPill({
    required this.icon,
    required this.label,
    required this.iconOnLeft,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textMuted;
    final children = [
      if (iconOnLeft) Icon(icon, size: 18, color: color),
      if (iconOnLeft) const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      if (!iconOnLeft) const SizedBox(width: 4),
      if (!iconOnLeft) Icon(icon, size: 18, color: color),
    ];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(children: children),
      ),
    );
  }
}
