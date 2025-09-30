/// Enum defining the statuses when submitting a cart
enum CartSubmitStatus {
  success,
  failed,
  throttled,
  error;

  bool get isSuccess => this == success;

  bool get isFailed => this == failed;

  bool get isThrottled => this == throttled;

  bool get isError => this == error;
}

/// Class containing the result of cart submission
class CartSubmitResult {
  final CartSubmitStatus status;
  final String? redirectUrl;
  final String? attemptId;
  final String? checkoutUrl;
  final String? pollAfter;
  final List<CartSubmitError> errors;

  CartSubmitResult({
    required this.status,
    this.redirectUrl,
    this.attemptId,
    this.checkoutUrl,
    this.pollAfter,
    this.errors = const [],
  });

  /// Created from GraphQL query response
  factory CartSubmitResult.fromJson(Map? json) {
    if (json == null) {
      return CartSubmitResult(
        status: CartSubmitStatus.error,
        errors: [
          CartSubmitError(
            code: 'UNKNOWN_ERROR',
            message: 'Unknown error occurred',
          )
        ],
      );
    }

    final result = json['result'];
    final userErrors = List<Map>.from(json['userErrors'] ?? []);

    // Case: user errors exist
    if (userErrors.isNotEmpty) {
      return CartSubmitResult(
        status: CartSubmitStatus.error,
        errors:
            userErrors.map((error) => CartSubmitError.fromJson(error)).toList(),
      );
    }

    // Case: submission successful
    if (result != null && result['__typename'] == 'SubmitSuccess') {
      return CartSubmitResult(
        status: CartSubmitStatus.success,
        redirectUrl: result['redirectUrl'],
        attemptId: result['attemptId'],
      );
    }

    // Case: submission failed
    if (result != null && result['__typename'] == 'SubmitFailed') {
      final errors = List<Map>.from(result['errors'] ?? []);
      return CartSubmitResult(
        status: CartSubmitStatus.failed,
        checkoutUrl: result['checkoutUrl'],
        errors: errors.map((error) => CartSubmitError.fromJson(error)).toList(),
      );
    }

    // Case: submission throttled (need to wait)
    if (result != null && result['__typename'] == 'SubmitThrottled') {
      return CartSubmitResult(
        status: CartSubmitStatus.throttled,
        pollAfter: result['pollAfter'],
      );
    }

    // Case: unknown error
    return CartSubmitResult(
      status: CartSubmitStatus.error,
      errors: [
        CartSubmitError(
          code: 'UNKNOWN_ERROR',
          message: 'Unknown error occurred',
        )
      ],
    );
  }

  /// Check if retry is needed (in case of throttled)
  bool get shouldRetry => status == CartSubmitStatus.throttled;

  /// Other helper methods
  bool get hasErrors => errors.isNotEmpty;

  String get errorMessage {
    if (errors.isEmpty) return '';
    return errors.map((e) => e.message).join(', ');
  }
}

/// Class containing error information
class CartSubmitError {
  final String? code;
  final String? field;
  final String message;

  CartSubmitError({
    this.code,
    this.field,
    required this.message,
  });

  factory CartSubmitError.fromJson(Map json) {
    return CartSubmitError(
      code: json['code'],
      field: json['field'],
      message: json['message'] ?? 'Unknown error',
    );
  }
}
