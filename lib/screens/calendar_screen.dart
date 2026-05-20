import 'package:flutter/material.dart';
import '../../../models/bible_verse.dart';
import '../../../widgets/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _year = 2026;
  int _month = 5;

  void _prevMonth() {
    setState(() {
      if (_month == 1) {
        _year--;
        _month = 12;
      } else {
        _month--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_month == 12) {
        _year++;
        _month = 1;
      } else {
        _month++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 40),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 560),
          padding: EdgeInsets.all(isMobile ? 22 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(isMobile),
              const SizedBox(height: 16),
              _buildDayLabels(isMobile),
              const SizedBox(height: 8),
              _buildGrid(isMobile),
              const SizedBox(height: 18),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),
              _buildLegend(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _prevMonth,
          child: Container(
            padding: const EdgeInsets.all(6),
            child: const Icon(Icons.chevron_left,
                color: AppColors.textMuted, size: 22),
          ),
        ),
        Text(
          '$_year년 $_month월',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        GestureDetector(
          onTap: _nextMonth,
          child: Container(
            padding: const EdgeInsets.all(6),
            child: const Icon(Icons.chevron_right,
                color: AppColors.textMuted, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildDayLabels(bool isMobile) {
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    return Row(
      children: days
          .map((d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildGrid(bool isMobile) {
    final firstDay = DateTime(_year, _month, 1).weekday % 7; // 0=일
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final gap = isMobile ? 5.0 : 8.0;

    // 셀 목록 (null = 빈칸)
    final cells = <int?>[];
    for (int i = 0; i < firstDay; i++) cells.add(null);
    for (int d = 1; d <= daysInMonth; d++) cells.add(d);

    // 7열 그리드 행으로 분할
    final rows = <List<int?>>[];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(cells.sublist(i, i + 7 > cells.length ? cells.length : i + 7));
    }

    return Column(
      children: rows
          .map((row) => Padding(
                padding: EdgeInsets.only(bottom: gap),
                child: Row(
                  children: List.generate(7, (col) {
                    final day = col < row.length ? row[col] : null;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: gap / 2),
                        child: _DayCell(day: day, isMobile: isMobile),
                      ),
                    );
                  }),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: AppColors.primary, label: '묵상 완료'),
        const SizedBox(width: 24),
        _LegendItem(
          color: AppColors.calEmpty,
          label: '묵상 없음',
          bordered: true,
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final int? day;
  final bool isMobile;
  const _DayCell({required this.day, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    // day가 null일 때 (달력의 빈 칸)
    if (day == null) {
      return const AspectRatio(
        aspectRatio: 1.0, // 필수 속성 추가 (1:1 비율)
        child: SizedBox(),
      );
    }

    final done = completedDays.contains(day);

    return AspectRatio(
      aspectRatio: 1.0, // 필수 속성 추가 (1:1 비율)
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: done ? AppColors.primary : AppColors.calEmpty,
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: done ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool bordered;

  const _LegendItem({
    required this.color,
    required this.label,
    this.bordered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: bordered ? Border.all(color: AppColors.border) : null,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
