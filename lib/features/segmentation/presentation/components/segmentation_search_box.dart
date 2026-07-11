import 'package:flutter/material.dart';

class SegmentationSearchBox extends StatefulWidget {
  const SegmentationSearchBox({
    required this.query,
    required this.resultCount,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final String query;
  final int resultCount;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<SegmentationSearchBox> createState() => _SegmentationSearchBoxState();
}

class _SegmentationSearchBoxState extends State<SegmentationSearchBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant SegmentationSearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = widget.query.trim().isNotEmpty;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: hasQuery
                    ? IconButton(
                        tooltip: 'Limpiar búsqueda',
                        onPressed: widget.onClear,
                        icon: const Icon(Icons.close),
                      )
                    : null,
                hintText: 'Buscar por perfil, programa, rezago o asistencia',
                border: const OutlineInputBorder(),
              ),
            ),
            if (hasQuery) ...[
              const SizedBox(height: 10),
              Text(
                '${widget.resultCount} resultado${widget.resultCount == 1 ? '' : 's'} para "${widget.query}"',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
