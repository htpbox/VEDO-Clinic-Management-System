class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'غير مصرح بالوصول'})
    : super(statusCode: 401);
}

class NetworkException extends AppException {
  const NetworkException() : super(message: '���� ������� �������');
}

class ServerException extends AppException {
  const ServerException({
    super.message = '��� ��� �� ������',
    super.statusCode,
  });
}

class ValidationException extends AppException {
  final List<String> errors;

  const ValidationException({required this.errors})
    : super(message: '��� �� �������� �������');
}
