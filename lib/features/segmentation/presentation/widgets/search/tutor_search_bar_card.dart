import 'package:flutter/material.dart';
import '../../theme/segmentation_dashboard_colors.dart';

class TutorSearchBarCard extends StatefulWidget {
  const TutorSearchBarCard({
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<TutorSearchBarCard> createState() => _TutorSearchBarCardState();
}

class _TutorSearchBarCardState extends State<TutorSearchBarCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SegmentationDashboardColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Busca alumnos...',
                hintStyle: const TextStyle(
                  color: SegmentationDashboardColors.textSecondary,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: SegmentationDashboardColors.textSecondary,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _controller.clear();
                          widget.onClear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                widget.onChanged(val);
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
              onPressed: () {
                // Futura funcionalidad de filtros avanzados
              },
            ),
          ),
        ],
      ),
    );
  }
}
