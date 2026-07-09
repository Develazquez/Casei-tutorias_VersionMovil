import 'package:flutter/material.dart';
import '../../theme/segmentation_dashboard_colors.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Accesos rápidos',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: SegmentationDashboardColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _QuickAccessCard(
              title: '¿Qué materias deben los críticos?',
              icon: Icons.error_outline_rounded,
              color: SegmentationDashboardColors.redCritical,
              onTap: () => _showUnavailable(context, 'materias adeudadas'),
            ),
            _QuickAccessCard(
              title: 'Materias del próximo cuatrimestre',
              icon: Icons.calendar_month_outlined,
              color: SegmentationDashboardColors.primaryBlue,
              onTap: () => _showUnavailable(context, 'oferta académica'),
            ),
            _QuickAccessCard(
              title: 'Materias con más alumnos en deuda',
              icon: Icons.format_list_numbered_rounded,
              color: SegmentationDashboardColors.orangeRisk,
              onTap: () => _showUnavailable(context, 'materias adeudadas'),
            ),
            _QuickAccessCard(
              title: 'Alumnos con asistencia < 60%',
              icon: Icons.person_off_outlined,
              color: Colors.deepOrange,
              onTap: () {
                // Futura integración directa con filtro
              },
            ),
            _QuickAccessCard(
              title: 'Próximos a egresar (sem. 8-9)',
              icon: Icons.school_outlined,
              color: SegmentationDashboardColors.turquoise,
            ),
            _QuickAccessCard(
              title: 'Atípicos: alto promedio, baja asist.',
              icon: Icons.query_stats_rounded,
              color: const Color(0xFF7C3AED),
            ),
          ],
        ),
      ],
    );
  }

  void _showUnavailable(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'La consulta de $feature no está disponible en la fuente actual.',
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SegmentationDashboardColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
