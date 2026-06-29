import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsbDebugGuard extends StatefulWidget {
  const UsbDebugGuard({required this.child, this.enabled = true, super.key});

  final Widget child;
  final bool enabled;

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
    if (widget.enabled) {
      _checkEnvironment();
    }
  }

  @override
  void didUpdateWidget(covariant UsbDebugGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled == oldWidget.enabled) return;
    if (widget.enabled) {
      _checkEnvironment();
    } else if (_blocked) {
      setState(() => _blocked = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.enabled && state == AppLifecycleState.resumed) {
      _checkEnvironment();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldBlock = widget.enabled && _blocked;
    return Stack(
      children: [
        AbsorbPointer(absorbing: shouldBlock, child: widget.child),
        if (shouldBlock)
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
    if (!widget.enabled) return;
    if (kDebugMode || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    try {
      final state = await _channel
          .invokeMapMethod<String, dynamic>('getEnvironmentState')
          .timeout(const Duration(seconds: 3));
      final adbEnabled = state?['adbEnabled'] == true;
      final developerOptionsEnabled = state?['developerOptionsEnabled'] == true;
      if (!mounted) return;
      if (!widget.enabled) return;
      setState(() => _blocked = adbEnabled || developerOptionsEnabled);
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _blocked = false);
    } on PlatformException {
      if (!mounted) return;
      setState(() => _blocked = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _blocked = false);
    }
  }
}
