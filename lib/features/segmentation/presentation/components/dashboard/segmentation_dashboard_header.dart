import 'package:flutter/material.dart';
import '../../../../../core/theme/cacei_ui_colors.dart';
import '../../../../../core/theme/segmentation_dashboard_colors.dart';

class SegmentationDashboardHeader extends StatelessWidget {
  const SegmentationDashboardHeader({
    required this.userName,
    required this.onMenuPressed,
    required this.currentIndex,
    required this.onTabChanged,
    super.key,
  });

  final String userName;
  final VoidCallback onMenuPressed;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SegmentationDashboardColors.headerBlue,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: onMenuPressed,
                tooltip: 'Abrir menú de navegación',
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: CaceiUiColors.avatarBackground,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: SegmentationDashboardColors.headerBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Tutor · CACEI',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Roboto',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'K-Means K=2',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DashboardTabs(
            currentIndex: currentIndex,
            onTabChanged: onTabChanged,
          ),
        ],
      ),
    );
  }
}

class _DashboardTabs extends StatelessWidget {
  const _DashboardTabs({
    required this.currentIndex,
    required this.onTabChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabItem(
          label: 'Dashboard',
          icon: Icons.dashboard_rounded,
          isActive: currentIndex == 0,
          onTap: () => onTabChanged(0),
        ),
        _TabItem(
          label: 'Modelo',
          icon: Icons.account_tree_outlined,
          isActive: currentIndex == 1,
          onTap: () => onTabChanged(1),
        ),
        _TabItem(
          label: 'Búsqueda',
          icon: Icons.search_rounded,
          isActive: currentIndex == 2,
          onTap: () {
            _showComingSoon(context);
            onTabChanged(2);
          },
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Esta sección se implementará en la siguiente etapa.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive
                  ? SegmentationDashboardColors.primaryBlue
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white54,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white54,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Roboto',
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
