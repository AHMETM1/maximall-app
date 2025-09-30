import 'dart:async';

/// # RetryManager
///
/// A generic utility for handling retry operations with sophisticated features like
/// exponential backoff, progress tracking, and error handling.
///
/// ## Overview
///
/// When working with network operations or other potentially unreliable actions,
/// you often need to retry the operation multiple times before giving up.
/// RetryManager offers a structured approach to handling retries with
/// configurable parameters and callbacks.
///
/// ## Features
///
/// - Generic implementation that works with any data type
/// - Configurable retry count and intervals
/// - Optional exponential backoff
/// - Progress tracking and state management
/// - Callbacks for retry attempts and completion
/// - Error handling and reporting
///
/// ## Basic Usage
///
/// ```dart
/// final retryManager = RetryManager<String>(
///   action: () async {
///     try {
///       final response = await http.get(Uri.parse('https://api.example.com/data'));
///
///       if (response.statusCode == 200) {
///         return RetryResult.success(response.body);
///       } else {
///         return RetryResult.failure('Failed with status: ${response.statusCode}');
///       }
///     } catch (e) {
///       return RetryResult.failure(e.toString());
///     }
///   },
///   maxRetries: 5,
///   retryInterval: Duration(seconds: 2),
///   onRetryAttempt: (status) {
///     print('Retry attempt ${status.currentAttempt}/${status.maxAttempts}');
///   },
///   onRetryComplete: (status) {
///     if (status.isSuccess) {
///       print('Success! Result: ${status.result}');
///     } else {
///       print('Failed after ${status.currentAttempt} attempts: ${status.errorMessage}');
///     }
///   },
/// );
///
/// // Start the retry process
/// await retryManager.start();
/// ```
///
/// ## Advanced Use Cases
///
/// ### With Exponential Backoff
///
/// ```dart
/// final retryManager = RetryManager<Response>(
///   action: fetchData,
///   maxRetries: 5,
///   retryInterval: Duration(seconds: 1),
///   backoffFactor: 2.0, // Each retry will wait 2x longer than the previous one
///   maxBackoffTime: Duration(seconds: 30), // Cap the maximum wait time
/// );
/// ```
///
/// ### API Polling
///
/// ```dart
/// // Poll until a job is complete
/// Future<JobResult> pollJobStatus(String jobId) async {
///   final retryManager = RetryManager<JobResult>(
///     action: () async {
///       final response = await api.getJobStatus(jobId);
///
///       if (response.status == 'completed') {
///         return RetryResult.success(response);
///       } else if (response.status == 'failed') {
///         return RetryResult.failure('Job failed: ${response.error}');
///       } else {
///         // Still in progress, retry
///         return RetryResult.failure('Job still in progress');
///       }
///     },
///     maxRetries: 30,
///     retryInterval: Duration(seconds: 5),
///   );
///
///   await retryManager.start();
///   if (retryManager.status.isSuccess) {
///     return retryManager.status.result!;
///   } else {
///     throw Exception('Job polling failed: ${retryManager.status.errorMessage}');
///   }
/// }
/// ```
///
/// ### Authentication Refresh
///
/// ```dart
/// Future<String?> getAuthenticatedData() async {
///   final retryManager = RetryManager<String>(
///     action: () async {
///       try {
///         final response = await http.get(
///           Uri.parse('https://api.example.com/protected-data'),
///           headers: {'Authorization': 'Bearer $currentToken'},
///         );
///
///         if (response.statusCode == 200) {
///           return RetryResult.success(response.body);
///         } else if (response.statusCode == 401) {
///           // Token expired, refresh it
///           final success = await refreshToken();
///           if (success) {
///             // Token refreshed, but we still need to retry the operation
///             return RetryResult.failure('Token refreshed, retry request');
///           } else {
///             return RetryResult.failure('Failed to refresh token');
///           }
///         } else {
///           return RetryResult.failure('API error: ${response.statusCode}');
///         }
///       } catch (e) {
///         return RetryResult.failure(e.toString());
///       }
///     },
///     maxRetries: 3,
///   );
///
///   await retryManager.start();
///   return retryManager.status.isSuccess ? retryManager.status.result : null;
/// }
/// ```
///
/// ## Best Practices
///
/// 1. **Define Clear Success/Failure Conditions**: Be explicit about what constitutes
///    success vs. what requires a retry.
///
/// 2. **Set Reasonable Retry Limits**: Consider both the maximum number of retries
///    and the interval between attempts based on the operation.
///
/// 3. **Add Exponential Backoff for External Services**: When dealing with third-party
///    services, use exponential backoff to avoid overwhelming them.
///
/// 4. **Clean Up Resources**: Always call `stop()` when your widget is disposed
///    to prevent memory leaks.
///
/// 5. **Use Type Parameters Effectively**: Take advantage of the generic nature
///    of RetryManager to handle different data types.
///
/// 6. **Provide Meaningful Error Messages**: When returning a failure result,
///    include specific error information that can help diagnose issues.
///
/// 7. **Update UI Appropriately**: Use the callbacks to update your UI to reflect
///    the current retry status.

/// Callback function to perform the action that needs to be retried
/// Returns true if successful, false if needs to be retried
typedef RetryAction<T> = Future<RetryResult<T>> Function();

/// Callback function called after each retry attempt
typedef OnRetryAttempt<T> = void Function(RetryStatus<T> status);

/// Callback function called when the retry process is complete (success or max retries reached)
typedef OnRetryComplete<T> = void Function(RetryStatus<T> status);

/// State of the retry process
enum RetryState {
  pending, // Not started yet
  inProgress, // Currently running
  success, // Successfully completed
  failed, // Failed after max retries
  canceled, // Was manually canceled
}

/// Result of a single retry attempt
class RetryResult<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;

  RetryResult({
    required this.isSuccess,
    this.data,
    this.errorMessage,
  });

  /// Create a successful result
  factory RetryResult.success(T? data) {
    return RetryResult(
      isSuccess: true,
      data: data,
    );
  }

  /// Create a failure result
  factory RetryResult.failure(String errorMessage) {
    return RetryResult(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}

/// Current status of the retry process
class RetryStatus<T> {
  final RetryState state;
  final int currentAttempt;
  final int maxAttempts;
  final Duration interval;
  final T? result;
  final String? errorMessage;

  RetryStatus({
    required this.state,
    required this.currentAttempt,
    required this.maxAttempts,
    required this.interval,
    this.result,
    this.errorMessage,
  });

  bool get isInProgress => state == RetryState.inProgress;

  bool get isSuccess => state == RetryState.success;

  bool get isFailed => state == RetryState.failed;

  bool get isCanceled => state == RetryState.canceled;

  double get progress => maxAttempts > 0 ? currentAttempt / maxAttempts : 0;

  int get remainingAttempts => maxAttempts - currentAttempt;
}

/// Manages the retry process for an action
class RetryManager<T> {
  /// Action to retry
  final RetryAction<T> action;

  /// Callback after each retry attempt
  final OnRetryAttempt<T>? onRetryAttempt;

  /// Callback when retry process is complete
  final OnRetryComplete<T>? onRetryComplete;

  /// Maximum number of retry attempts
  final int maxRetries;

  /// Interval between retry attempts
  final Duration retryInterval;

  /// Backoff strategy factor (increase interval between retries)
  final double backoffFactor;

  /// Maximum backoff time between retries
  final Duration? maxBackoffTime;

  /// Current state
  RetryState _state = RetryState.pending;

  /// Number of retry attempts made
  int _retryCount = 0;

  /// Timer for next retry
  Timer? _retryTimer;

  /// Final result
  T? _result;

  /// Error message
  String? _errorMessage;

  RetryManager({
    required this.action,
    this.onRetryAttempt,
    this.onRetryComplete,
    this.maxRetries = 10,
    this.retryInterval = const Duration(seconds: 1),
    this.backoffFactor = 1.0, // 1.0 = no increase in time between retries
    this.maxBackoffTime,
  });

  /// Current state
  RetryState get state => _state;

  /// Number of retry attempts made
  int get retryCount => _retryCount;

  /// Number of retry attempts remaining
  int get remainingRetries => maxRetries - _retryCount;

  /// Is currently retrying?
  bool get isRetrying => _state == RetryState.inProgress;

  /// Get current status
  RetryStatus<T> get status => RetryStatus<T>(
        state: _state,
        currentAttempt: _retryCount,
        maxAttempts: maxRetries,
        interval: _getCurrentInterval(),
        result: _result,
        errorMessage: _errorMessage,
      );

  /// Start the retry process
  Future<void> start() async {
    if (_state == RetryState.inProgress) {
      return; // Already retrying, do nothing
    }

    _resetState();
    await _executeRetry();
  }

  /// Reset state to start over
  void _resetState() {
    _state = RetryState.inProgress;
    _retryCount = 0;
    _result = null;
    _errorMessage = null;
    _retryTimer?.cancel();
  }

  /// Stop the retry process
  void stop() {
    _retryTimer?.cancel();
    _state = RetryState.canceled;
    _notifyRetryComplete();
  }

  /// Execute the retry attempt
  Future<void> _executeRetry() async {
    if (_state != RetryState.inProgress || _retryCount >= maxRetries) {
      _state = RetryState.failed;
      _notifyRetryComplete();
      return;
    }

    _retryCount++;
    _notifyRetryAttempt();

    try {
      final result = await action();

      if (result.isSuccess) {
        _result = result.data;
        _state = RetryState.success;
        _notifyRetryComplete();
      } else {
        _errorMessage = result.errorMessage;

        if (_retryCount >= maxRetries) {
          _state = RetryState.failed;
          _notifyRetryComplete();
        } else {
          _scheduleNextRetry();
        }
      }
    } catch (e) {
      _errorMessage = e.toString();

      if (_retryCount >= maxRetries) {
        _state = RetryState.failed;
        _notifyRetryComplete();
      } else {
        _scheduleNextRetry();
      }
    }
  }

  /// Calculate interval for next retry (supports exponential backoff)
  Duration _getCurrentInterval() {
    if (backoffFactor <= 1.0) {
      return retryInterval;
    }

    final interval = Duration(
      milliseconds:
          (retryInterval.inMilliseconds * (backoffFactor * (_retryCount - 1)))
              .toInt(),
    );

    if (maxBackoffTime != null && interval > maxBackoffTime!) {
      return maxBackoffTime!;
    }

    return interval;
  }

  /// Schedule the next retry attempt
  void _scheduleNextRetry() {
    final interval = _getCurrentInterval();

    _retryTimer?.cancel();
    _retryTimer = Timer(interval, () async {
      await _executeRetry();
    });
  }

  /// Notify listeners about retry attempt
  void _notifyRetryAttempt() {
    onRetryAttempt?.call(status);
  }

  /// Notify listeners that retry process is complete
  void _notifyRetryComplete() {
    onRetryComplete?.call(status);
  }
}
