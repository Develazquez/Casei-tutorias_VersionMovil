import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsbDebugGuard extends StatefulWidget {
  const UsbDebugGuard({required this.child, super.key});

  final Widget child;

  @override
  State<UsbDebugGuard> createState() => _UsbDebugGuardState();
}

class _UsbDebugGuardState extends State<UsbDebugGuard>
    with WidgetsBindingObserver {
  static const _channel = MethodChannel(
    'mx.edu.upchiapas.casei_tutorias/security',
  );

  bool _blocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkEnvironment();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkEnvironment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(absorbing: _blocked, child: widget.child),
        if (_blocked)
          Positioned.fill(
            child: ColoredBox(
              color: const Color(0xFF111827),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.security, color: Colors.white, size: 76),
                      const SizedBox(height: 18),
                      Text(
                        'ENTORNO NO SEGURO',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Desactiva la depuración USB y las opciones de desarrollador para acceder a CASEI Tutorías.',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _checkEnvironment() async {
    if (kDebugMode || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    try {
      final state = await _channel.invokeMapMethod<String, dynamic>(
        'getEnvironmentState',
      );
      final adbEnabled = state?['adbEnabled'] == true;
      final developerOptionsEnabled = state?['developerOptionsEnabled'] == true;
      if (!mounted) return;
      setState(() => _blocked = adbEnabled || developerOptionsEnabled);
    } on PlatformException {
      if (!mounted) return;
      setState(() => _blocked = false);
    }
  }
}
