import 'package:casei_tutorias/app.dart';
import 'package:casei_tutorias/core/constants/app_constants.dart';
import 'package:casei_tutorias/features/auth/presentation/providers/auth_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_provider.dart';
import 'package:casei_tutorias/injection_container.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('renders login page', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      publishableKey: AppConstants.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: false),
    );
    await di.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
          ChangeNotifierProvider(create: (_) => di.sl<SegmentationProvider>()),
        ],
        child: const CaseiTutoriasApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('CASEI Tutorías'), findsOneWidget);
    expect(find.text('Dashboard de segmentación académica'), findsOneWidget);
  });
}
