import 'package:flutter/material.dart';
import 'app_colors.dart'; // AppColors 클래스 표준 구조 가정

class MeditationCard extends StatelessWidget {
  final TextEditingController controller;
  final String meditation;
  final bool compact;

  const MeditationCard({
    super.key,
    required this.controller,
    required this.meditation,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. 카드가 배치될 기본 안쪽 패딩 지정
      padding: EdgeInsets.all(compact ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── [헤더] 타이틀 및 상단 액션 바 ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '나의 묵상',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.text_fields, size: 18),
                    color: AppColors.primary,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit_note, size: 18),
                    color: AppColors.textMuted,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: compact ? 12 : 16),

          // ── [본문] 텍스트 입력 영역 (카드 안에서만 스크롤이 발생하도록 제한) ──
          Expanded(
            child: GestureDetector(
              // 입력창 바깥의 카드 빈 공간을 눌러도 커서가 가도록 설정
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scrollbar(
                thumbVisibility: true, // 스크롤바 상시 표시하여 인지성 향상
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: TextField(
                    controller: controller,
                    maxLines: null, // 글자 수 제한 없이 무한 입력 가능하게 설정
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.75,
                      color: AppColors.text,
                    ),
                    decoration: const InputDecoration(
                      hintText: '이 말씀을 묵상하며 떠오른 생각들을 자유롭게 적어보세요...',
                      hintStyle: TextStyle(color: AppColors.textLight),
                      border: InputBorder.none, // 텍스트필드 자체 기본 테두리 제거
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── [푸터] 텍스트가 존재할 때만 늘어나는 저장 버튼 ──
          if (meditation.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('묵상이 성공적으로 저장되었습니다.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '묵상 저장하기',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
