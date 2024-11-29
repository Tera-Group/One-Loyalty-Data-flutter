class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.statusCode,
  });


  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool,
      data: json['data'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'statusCode': statusCode,
    };
  }
}