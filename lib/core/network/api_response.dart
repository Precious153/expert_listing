class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? '',
      data: fromJsonT != null && json['data'] != null ? fromJsonT(json['data']) : json['data'] as T?,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  bool get isSuccess => status == 'success';
}
