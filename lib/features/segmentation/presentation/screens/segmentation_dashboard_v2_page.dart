import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../tutor_navigation/presentation/components/tutor_navigation_drawer.dart';
import '../components/dashboard/segmentation_dashboard_header.dart';
import '../components/dashboard/segmentation_dashboard_view.dart';
import '../components/model/segmentation_model_view.dart';
import '../components/search/segmentation_search_view.dart';
import '../components/tutorados/tutorados_view.dart';
import '../providers/segmentation_dashboard_provider.dart';
import '../providers/segmentation_navigation_provider.dart';
import '../providers/segmentation_provider.dart';

class SegmentationDashboardV2Page extends StatefulWidget {
  const SegmentationDashboardV2Page({super.key});

  @override
  State<SegmentationDashboardV2Page> createState() =>
      _SegmentationDashboardV2PageState();
}

class _SegmentationDashboardV2PageState
    extends State<SegmentationDashboardV2Page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      context.read<SegmentationProvider>().load(
        role: auth.user?.role,
        userId: auth.user?.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<
      SegmentationDashboardProvider,
      SegmentationNavigationProvider
    >(
      builder: (context, dashboardProvider, navigationProvider, child) {
        final auth = context.watch<AuthProvider>();
        final theme = Theme.of(context);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: theme.colorScheme.surface,
          drawer: const TutorNavigationDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                SegmentationDashboardHeader(
                  userName: auth.user?.name ?? 'Diego Velázquez Méndez',
                  onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  currentIndex: navigationProvider.currentTabIndex,
                  onTabChanged: navigationProvider.setTab,
                ),
                Expanded(
                  child: IndexedStack(
                    index: navigationProvider.currentTabIndex,
                    children: const [
                      SegmentationDashboardView(),
                      SegmentationModelView(),
                      SegmentationSearchView(),
                      TutoradosView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
