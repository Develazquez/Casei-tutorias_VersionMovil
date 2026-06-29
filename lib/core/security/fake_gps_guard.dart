import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class FakeGpsGuard extends StatefulWidget {
  const FakeGpsGuard({required this.child, this.enabled = true, super.key});

  final Widget child;
  final bool enabled;

  @override
  State<FakeGpsGuard> createState() => _FakeGpsGuardState();
}

class _FakeGpsGuardState extends State<FakeGpsGuard> {
  StreamSubscription<Position>? _subscription;
  bool _mockLocationDetected = false;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _startMonitoring();
    }
  }

  @override
  void didUpdateWidget(covariant FakeGpsGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled == oldWidget.enabled) return;
    if (widget.enabled) {
      _startMonitoring();
    } else {
      _subscription?.cancel();
      _subscription = null;
      if (_mockLocationDetected) {
        setState(() => _mockLocationDetected = false);
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldBlock = widget.enabled && _mockLocationDetected;
    return Stack(
      children: [
        AbsorbPointer(absorbing: shouldBlock, child: widget.child),
        if (shouldBlock)
          const _SecurityBlocker(
            icon: Icons.location_off,
            title: 'Ubicación no confiable',
            message:
                'Se detectó una ubicación simulada. Desactiva Fake GPS y vuelve a abrir la app.',
            color: Color(0xFFB3261E),
          ),
      ],
    );
  }

  Future<void> _startMonitoring() async {
    if (_subscription != null || !widget.enabled) return;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 4));
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission().timeout(
        const Duration(seconds: 4),
      );
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission().timeout(
          const Duration(seconds: 10),
        );
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      _subscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
              distanceFilter: 25,
            ),
          ).listen((position) {
            if (!mounted) return;
            if (!widget.enabled) return;
            setState(() => _mockLocationDetected = position.isMocked);
          });
    } on TimeoutException {
      return;
    } catch (_) {
      return;
    }
  }
}

class _SecurityBlocker extends StatelessWidget {
  const _SecurityBlocker({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: color,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 72, color: Colors.white),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
