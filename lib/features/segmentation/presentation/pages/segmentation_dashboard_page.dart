import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/view_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/segmentation_provider.dart';
import '../widgets/cluster_card.dart';
import '../widgets/filter_bar.dart';
import '../widgets/metric_tile.dart';
import '../widgets/student_list.dart';

class SegmentationDashboardPage extends StatefulWidget {
  const SegmentationDashboardPage({super.key});

  @override
  State<SegmentationDashboardPage> createState() =>
      _SegmentationDashboardPageState();
}

class _SegmentationDashboardPageState extends State<SegmentationDashboardPage> {
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
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<SegmentationProvider>();
    final summary = provider.summary;
    final isTutor = auth.user?.isTutor ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTutor
              ? 'Mis tutorados por perfil'
              : 'Segmentación académica institucional',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(child: Text(auth.user?.name ?? '')),
          ),
          IconButton(
            tooltip: 'Baúl encriptado',
            onPressed: () => Navigator.pushNamed(context, '/security/vault'),
            icon: const Icon(Icons.lock_outline),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: provider.state == ViewState.loading
            ? const Center(child: CircularProgressIndicator())
            : provider.state == ViewState.error
            ? Center(child: Text(provider.errorMessage ?? 'Error'))
            : summary == null
            ? const Center(child: Text('Sin datos disponibles.'))
            : RefreshIndicator(
                onRefresh: () => provider.load(role: auth.user?.role),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      isTutor
                          ? 'Prioriza sesiones, revisa asistencia y da seguimiento a tutorados con rezago.'
                          : 'Vista ejecutiva de perfiles académicos detectados por clustering no supervisado.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        MetricTile(
                          icon: Icons.people_alt_outlined,
                          label: 'Estudiantes',
                          value: '${summary.totalStudents}',
                        ),
                        MetricTile(
                          icon: Icons.grade_outlined,
                          label: 'Promedio',
                          value: summary.averageGrade.toStringAsFixed(1),
                        ),
                        MetricTile(
                          icon: Icons.event_available_outlined,
                          label: 'Asistencia',
                          value:
                              '${summary.attendanceRate.toStringAsFixed(1)}%',
                        ),
                        MetricTile(
                          icon: Icons.warning_amber_outlined,
                          label: 'En seguimiento',
                          value: '${summary.riskStudents}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: summary.clusters.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.sizeOf(context).width > 920
                            ? 4
                            : MediaQuery.sizeOf(context).width > 620
                            ? 2
                            : 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 190,
                      ),
                      itemBuilder: (context, index) {
                        return ClusterCard(
                          cluster: summary.clusters[index],
                          totalStudents: summary.totalStudents,
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    FilterBar(
                      profiles: provider.profiles,
                      programs: provider.programs,
                      selectedProfile: provider.selectedProfile,
                      selectedProgram: provider.selectedProgram,
                      onProfileChanged: (value) =>
                          provider.changeProfile(value, role: auth.user?.role),
                      onProgramChanged: (value) =>
                          provider.changeProgram(value, role: auth.user?.role),
                    ),
                    const SizedBox(height: 12),
                    StudentList(students: provider.students),
                  ],
                ),
              ),
      ),
    );
  }
}
