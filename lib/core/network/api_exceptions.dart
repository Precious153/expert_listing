class ApiException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ApiException(this.message, {this.errors, this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class TimeoutException extends ApiException {
  TimeoutException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class ValidationException extends ApiException {
  ValidationException(super.message, {super.errors});
}

class ServerException extends ApiException {
  ServerException(super.message);
}
