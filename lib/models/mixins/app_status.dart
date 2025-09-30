import '../../common/error_codes/error_codes.dart';

/// Enum defining the types of status
enum StatusType {
  /// Success status
  success,

  /// Error status
  error,

  /// Loading status
  loading,

  /// Processing status
  processing,

  /// Information status
  info,

  /// Warning status
  warning,
}

/// Common class for all application status
class AppStatus {
  /// Type of status
  final StatusType type;

  /// Additional data (if any)
  final dynamic data;

  /// Error type (if any)
  final ErrorType? errorType;

  /// Create a status
  const AppStatus({
    required this.type,
    this.data,
    this.errorType,
  });

  /// Create a success status
  factory AppStatus.success({dynamic data}) {
    return AppStatus(
      type: StatusType.success,
      data: data,
    );
  }

  /// Create an error status
  factory AppStatus.error({dynamic data, ErrorType? errorType}) {
    return AppStatus(
      type: StatusType.error,
      data: data,
      errorType: errorType,
    );
  }

  /// Create a loading status
  factory AppStatus.loading({dynamic data}) {
    return AppStatus(
      type: StatusType.loading,
      data: data,
    );
  }

  /// Create a processing status
  factory AppStatus.processing({dynamic data}) {
    return AppStatus(
      type: StatusType.processing,
      data: data,
    );
  }

  /// Create an information status
  factory AppStatus.info({dynamic data}) {
    return AppStatus(
      type: StatusType.info,
      data: data,
    );
  }

  /// Create a warning status
  factory AppStatus.warning({dynamic data}) {
    return AppStatus(
      type: StatusType.warning,
      data: data,
    );
  }

  /// Check if this is an error status
  bool get isError => type == StatusType.error;

  /// Check if this is a success status
  bool get isSuccess => type == StatusType.success;

  /// Check if this is a loading status
  bool get isLoading => type == StatusType.loading;

  /// Check if this is a processing status
  bool get isProcessing => type == StatusType.processing;

  /// Check if this is an information status
  bool get isInfo => type == StatusType.info;

  /// Check if this is a warning status
  bool get isWarning => type == StatusType.warning;

  @override
  String toString() =>
      '${type.name}${errorType != null ? ' - $errorType' : ''}';
}
