import 'package:flutter/material.dart';
import '../models/bible_verse.dart'; // DrawingLine 모델 임포트
import 'app_colors.dart';

class MeditationCard extends StatefulWidget {
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
  State<MeditationCard> createState() => _MeditationCardState();
}

class _MeditationCardState extends State<MeditationCard> {
  bool _isCanvasMode = false; // false = 텍스트 모드, true = 캔버스(필기) 모드
  List<DrawingLine> _lines = <DrawingLine>[]; // 필기 선들을 저장하는 리스트

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.compact ? 18 : 24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 헤더 영역 (모드 전환 및 도구)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isCanvasMode ? '나의 묵상 (필기)' : '나의 묵상 (텍스트)',
                style: TextStyle(
                  fontSize: widget.compact ? 14 : 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Row(
                children: [
                  // 필기 모드일 때만 보이는 지우개 버튼
                  if (_isCanvasMode) ...[
                    GestureDetector(
                      onTap: () => setState(() => _lines.clear()),
                      child: const Container(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.delete_outline,
                            size: 18, color: Colors.redAccent),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  // 텍스트 모드 전환 버튼
                  GestureDetector(
                    onTap: () => setState(() => _isCanvasMode = false),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: !_isCanvasMode
                            ? AppColors.primaryLight
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.title,
                          size: 16,
                          color: !_isCanvasMode
                              ? AppColors.primary
                              : AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // 캔버스(필기) 모드 전환 버튼
                  GestureDetector(
                    onTap: () => setState(() => _isCanvasMode = true),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _isCanvasMode
                            ? AppColors.primaryLight
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.edit_outlined,
                          size: 16,
                          color: _isCanvasMode
                              ? AppColors.primary
                              : AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. 본문 영역 (텍스트 입력기 또는 드로잉 캔버스)
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isCanvasMode ? _buildCanvasArea() : _buildTextArea(),
            ),
          ),

          const SizedBox(height: 10),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),

          // 3. 저장 버튼 영역 (텍스트 내용이 있거나 필기 선이 있을 때 활성화)
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: (widget.meditation.isNotEmpty || _lines.isNotEmpty)
                  ? () {
                      // 실제 저장 로직이 들어갈 자리 (현재는 팝업 알림)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isCanvasMode
                              ? '필기한 묵상이 내 기기에 저장되었습니다 🙏'
                              : '작성하신 묵상 텍스트가 저장되었습니다 🙏'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  : null, // 내용이 전혀 없으면 버튼 비활성화
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.border,
                disabledForegroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: const Text(
                '묵상 저장하기',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 키보드 텍스트 입력 영역 ──
  Widget _buildTextArea() {
    return TextField(
      key: const ValueKey('text_mode'),
      controller: widget.controller,
      maxLines: null,
      minLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: '이 말씀을 묵상하며 떠오른 생각들을 자유롭게 적어보세요...',
        hintStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 13,
          height: 1.75,
        ),
        contentPadding: EdgeInsets.zero,
      ),
      style: const TextStyle(
        fontSize: 13,
        height: 1.75,
        color: AppColors.textDark,
      ),
    );
  }

  // ── 손글씨/마우스 필기 캔버스 영역 ──
  Widget _buildCanvasArea() {
    return Container(
      key: const ValueKey('canvas_mode'),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              Offset localPosition =
                  renderBox.globalToLocal(details.globalPosition);
              // 헤더 높이 패딩 등을 감안하여 내부 캔버스 상대 좌표로 선 시작
              _lines.add(DrawingLine(points: [localPosition]));
            });
          },
          onPanUpdate: (details) {
            setState(() {
              if (_lines.isEmpty) return;
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              Offset localPosition =
                  renderBox.globalToLocal(details.globalPosition);

              // 현재 그리고 있는 선에 좌표 연속 추가
              List<Offset> points = List.from(_lines.last.points)
                ..add(localPosition);
              _lines[_lines.length - 1] = DrawingLine(
                points: points,
                color: AppColors.primary,
                strokeWidth: 3.5,
              );
            });
          },
          child: CustomPaint(
            painter: MeditationPainter(lines: _lines),
            child: _lines.isEmpty
                ? const Center(
                    child: Text(
                      '이곳에 손가락이나 펜으로 자유롭게 필기하세요 ✍️',
                      style:
                          TextStyle(color: AppColors.textLight, fontSize: 12),
                    ),
                  )
                : const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

// ── 필기 선을 화면에 그려주는 Painter ──────────────────
class MeditationPainter extends CustomPainter {
  final List<DrawingLine> lines;
  MeditationPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = line.strokeWidth
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MeditationPainter oldDelegate) {
    return oldDelegate.lines != lines;
  }
}
