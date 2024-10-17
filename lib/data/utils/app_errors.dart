class AppError {
  final String message;
  final Object? exception;

  AppError(this.message, {this.exception});

  @override
  String toString() {
    return 'Message: $message\nError: ${exception.toString()}';
  }
}
