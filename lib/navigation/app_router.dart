import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/auth_checker.dart';
import '../features/auth/presentation/screens/login_page.dart';
import '../features/auth/presentation/screens/register_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/security/presentation/screens/secure_vault_page.dart';
import '../features/segmentation/presentation/screens/segmentation_dashboard_v2_page.dart';
import 'app_navigator.dart';
import 'app_screen.dart';

abstract final class AppRouter {
  static GoRouter create(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: AppNavigator.key,
      initialLocation: AppScreen.sessionCheck.route,
      refreshListenable: authProvider,
      routes: [
        GoRoute(
          path: AppScreen.sessionCheck.route,
          name: AppScreen.sessionCheck.name,
          builder: (_, _) => const AuthChecker(),
        ),
        GoRoute(
          path: AppScreen.authCallback.route,
          name: AppScreen.authCallback.name,
          builder: (_, _) => const AuthChecker(),
        ),
        GoRoute(
          path: AppScreen.login.route,
          name: AppScreen.login.name,
          builder: (_, _) => const LoginPage(),
        ),
        GoRoute(
          path: AppScreen.register.route,
          name: AppScreen.register.name,
          builder: (_, _) => const RegisterPage(),
        ),
        GoRoute(
          path: AppScreen.segmentation.route,
          name: AppScreen.segmentation.name,
          builder: (_, _) => const SegmentationDashboardV2Page(),
        ),
        GoRoute(
          path: AppScreen.secureVault.route,
          name: AppScreen.secureVault.name,
          builder: (_, _) => const SecureVaultPage(),
        ),
      ],
      redirect: (_, state) {
        final location = state.matchedLocation;
        final isPublicRoute =
            location == AppScreen.sessionCheck.route ||
            location == AppScreen.authCallback.route ||
            location == AppScreen.login.route ||
            location == AppScreen.register.route;
        final isAuthenticatedTutor =
            authProvider.isAuthenticated && authProvider.user?.isTutor == true;

        if (!isAuthenticatedTutor && !isPublicRoute) {
          return AppScreen.login.route;
        }

        return null;
      },
    );
  }
}
