class ApiReturn<T> {
  final T data;
  final String message;
  final bool success;

  ApiReturn({
    this.data,
    this.message,
    this.success
  });

  factory ApiReturn.fromMap(Map<String, dynamic> map) {
    return new ApiReturn(
      data: map['data'] as T,
      message: map['message'] as String,
      success: map['success'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'data': this.data,
      'message': this.message,
      'success': this.success,
    } as Map<String, dynamic>;
  }
}