import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home_screen.dart';
import '../screens/sharing_screen.dart';
import '../screens/calendar_screen.dart';

void main() {
  runApp(const BibleQTApp());
}

class BibleQTApp extends StatelessWidget {
  const BibleQTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '성경 QT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1DB87A)),
        textTheme: GoogleFonts.notoSansKrTextTheme(),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

// ── 앱 전체를 감싸는 Shell (사이드바 + 콘텐츠) ──────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 2; // 0=캘린더, 1=나눔, 2=홈

  final List<Widget> _screens = const [
    CalendarScreen(),
    SharingScreen(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isNarrow = MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      body: Row(
        children: [
          // ── 사이드바 (항상 표시) ──
          _Sidebar(
            selectedIndex: _selectedIndex,
            isNarrow: isNarrow,
            onTap: (i) => setState(() => _selectedIndex = i),
          ),
          // ── 콘텐츠 영역 ──
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}

// ── 사이드바 ────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final bool isNarrow;
  final void Function(int) onTap;

  const _Sidebar({
    required this.selectedIndex,
    required this.isNarrow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.calendar_month_outlined, Icons.calendar_month, '캘린더'),
      (Icons.people_outline, Icons.people, '나눔'),
      (Icons.home_outlined, Icons.home, '홈'),
    ];

    return Container(
      width: isNarrow ? 54 : 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE5EDE9))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ...List.generate(items.length, (i) {
            final isSelected = selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _NavButton(
                icon: isSelected ? items[i].$2 : items[i].$1,
                label: items[i].$3,
                isSelected: isSelected,
                size: isNarrow ? 40 : 44,
                onTap: () => onTap(i),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final double size;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F8F0) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color:
                isSelected ? const Color(0xFF1DB87A) : const Color(0xFF6B7E8F),
            size: 22,
          ),
        ),
      ),
    );
  }
}
