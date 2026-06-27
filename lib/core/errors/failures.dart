abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class AuthException extends AppException {
  const AuthException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}
