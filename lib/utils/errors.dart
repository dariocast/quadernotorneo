class AppError implements Exception {
  final String message;

  const AppError(this.message);

  @override
  String toString() => message;
}

class NetworkError extends AppError {
  const NetworkError(String message) : super(message);
}

class AuthenticationError extends AppError {
  const AuthenticationError(String message) : super(message);
}

class DatabaseError extends AppError {
  const DatabaseError(String message) : super(message);
}

class ValidationError extends AppError {
  const ValidationError(String message) : super(message);
}
