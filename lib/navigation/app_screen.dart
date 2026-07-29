enum AppScreen {
  sessionCheck('/'),
  authCallback('/auth'),
  login('/login'),
  register('/register'),
  segmentation('/segmentation'),
  secureVault('/security/vault');

  const AppScreen(this.route);

  final String route;
}
