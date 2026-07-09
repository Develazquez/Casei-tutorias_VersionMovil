import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../tutor_navigation/presentation/providers/tutor_navigation_view_model.dart';
import '../../../tutor_navigation/presentation/widgets/tutor_navigation_drawer.dart';
import '../providers/segmentation_dashboard_view_model.dart';
import '../providers/segmentation_navigation_view_model.dart';
import '../providers/segmentation_provider.dart';
import '../theme/segmentation_dashboard_colors.dart';
import '../widgets/dashboard/segmentation_dashboard_header.dart';
import '../widgets/dashboard/segmentation_dashboard_view.dart';
import '../widgets/model/segmentation_model_view.dart';
import '../widgets/search/segmentation_search_view.dart';

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
      final role = context.read<AuthProvider>().user?.role;
      context.read<SegmentationProvider>().load(role: role);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SegmentationDashboardViewModel(
            context.read<SegmentationProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SegmentationNavigationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              TutorNavigationViewModel(initialId: 'segmentation'),
        ),
      ],
      child:
          Consumer2<
            SegmentationDashboardViewModel,
            SegmentationNavigationViewModel
          >(
            builder: (context, dashboardVm, navViewModel, child) {
              final auth = context.watch<AuthProvider>();

              return Scaffold(
                key: _scaffoldKey,
                backgroundColor: SegmentationDashboardColors.background,
                drawer: const TutorNavigationDrawer(),
                body: SafeArea(
                  child: Column(
                    children: [
                      SegmentationDashboardHeader(
                        userName: auth.user?.name ?? 'Diego Velázquez Méndez',
                        onMenuPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                        currentIndex: navViewModel.currentTabIndex,
                        onTabChanged: navViewModel.setTab,
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: navViewModel.currentTabIndex,
                          children: const [
                            SegmentationDashboardView(),
                            SegmentationModelView(),
                            SegmentationSearchView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
