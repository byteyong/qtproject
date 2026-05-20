import 'package:flutter/material.dart';
import '../../../models/bible_verse.dart';
import '../../../widgets/app_colors.dart';

class SharingScreen extends StatefulWidget {
  const SharingScreen({super.key});

  @override
  State<SharingScreen> createState() => _SharingScreenState();
}

class _SharingScreenState extends State<SharingScreen> {
  final Map<int, bool> _amenMap = {};

  void _toggleAmen(int id) {
    setState(() => _amenMap[id] = !(_amenMap[id] ?? false));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;
    final hPad = isMobile ? 16.0 : 80.0;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 22 : 40, hPad, 24),
      itemCount: sharingData.length + 1,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Text(
              '나눔',
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          );
        }
        final post = sharingData[i - 1];
        final isAmened = _amenMap[post.id] ?? false;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _SharingCard(
            post: post,
            isAmened: isAmened,
            onAmen: () => _toggleAmen(post.id),
            isMobile: isMobile,
          ),
        );
      },
    );
  }
}

class _SharingCard extends StatelessWidget {
  final SharingPost post;
  final bool isAmened;
  final VoidCallback onAmen;
  final bool isMobile;

  const _SharingCard({
    required this.post,
    required this.isAmened,
    required this.onAmen,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 28),
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
          // 프로필 헤더
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  post.name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    post.daysAgo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 성경 참조
          Text(
            post.ref,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 5),
          // 성경 구절
          Text(
            post.verse,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // 내용
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 12),
          // 하이라이트 박스
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              post.highlight,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // 아멘 버튼
          GestureDetector(
            onTap: onAmen,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAmened ? Icons.favorite : Icons.favorite_border,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '아멘  ${post.amen + (isAmened ? 1 : 0)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isAmened ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
