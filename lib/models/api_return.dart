class ApiReturn<T> {
  final T data;
  final String message;
  final bool status;

  ApiReturn({
    this.data,
    this.message,
    this.status
  });

  factory ApiReturn.fromMap(Map<String, dynamic> map) {
    return new ApiReturn(
      data: map['data'] as T,
      message: map['message'] as String,
      status: map['status'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'data': this.data,
      'message': this.message,
      'status': this.status,
    } as Map<String, dynamic>;
  }
}