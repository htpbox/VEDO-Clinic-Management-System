class ApiResponseEnvelope<T> {
  final bool success;
  final String message;
  final T? data;
  final List<String> errors;

  const ApiResponseEnvelope({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory ApiResponseEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponseEnvelope<T>(
      success: json['success'] as bool,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors:
          (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
