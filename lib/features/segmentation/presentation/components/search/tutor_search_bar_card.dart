import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

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
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: appColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Busca alumnos...',
                hintStyle: TextStyle(
                  color: appColors.mutedText,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: appColors.mutedText,
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
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              iconSize: 20,
              icon: Icon(Icons.filter_list_rounded, color: theme.colorScheme.onPrimary),
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
