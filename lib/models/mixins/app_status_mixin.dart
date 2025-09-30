import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../common/error_codes/error_codes.dart';
import 'app_status.dart';

/// Listener definition for status events
typedef StatusListener = void Function(AppStatus status);

/// A mixin that provides unified status handling and event listening functionality
/// Can be used by any model that extends ChangeNotifier
mixin AppStatusMixin on ChangeNotifier {
  /// Stream controller for status events
  final _statusController = StreamController<AppStatus>.broadcast();

  /// Last emitted status, stored for sync access
  AppStatus? _lastStatus;

  /// Current statuses by type, for tracking multiple concurrent statuses
  final Map<StatusType, AppStatus> _statusByType = {};

  /// Public stream of status events
  Stream<AppStatus> get statusStream => _statusController.stream;

  /// Get current status
  AppStatus? get currentStatus => _lastStatus;

  /// Check if there's a loading status active
  bool get isLoading => _statusByType[StatusType.loading] != null;

  /// Check if there's an error status active
  bool get hasError => _statusByType[StatusType.error] != null;

  /// Get current error type
  ErrorType? get errorType => _statusByType[StatusType.error]?.errorType;

  /// Subscribe to all status events
  /// Returns a subscription that can be used to cancel the listener
  StreamSubscription<AppStatus> addStatusListener(StatusListener listener) {
    return _statusController.stream.listen(listener);
  }

  /// Subscribe to specific status type events
  /// Returns a subscription that can be used to cancel the listener
  StreamSubscription<AppStatus> addStatusTypeListener(
    StatusType type,
    StatusListener listener,
  ) {
    return _statusController.stream
        .where((status) => status.type == type)
        .listen(listener);
  }

  /// Subscribe to error status events
  /// Returns a subscription that can be used to cancel the listener
  StreamSubscription<AppStatus> addErrorListener(StatusListener listener) {
    return addStatusTypeListener(StatusType.error, listener);
  }

  /// Subscribe to success status events
  /// Returns a subscription that can be used to cancel the listener
  StreamSubscription<AppStatus> addSuccessListener(StatusListener listener) {
    return addStatusTypeListener(StatusType.success, listener);
  }

  /// Subscribe to processing status events
  /// Returns a subscription that can be used to cancel the listener
  StreamSubscription<AppStatus> addProcessingListener(StatusListener listener) {
    return addStatusTypeListener(StatusType.processing, listener);
  }

  /// Emit a status event and update the status maps
  void emitStatus(AppStatus status) {
    _lastStatus = status;
    _statusByType[status.type] = status;
    _statusController.add(status);
    notifyListeners();
  }

  /// Emit an error status
  void emitError({ErrorType? errorType, dynamic data}) {
    emitStatus(AppStatus.error(data: data, errorType: errorType));
  }

  /// Emit a success status
  void emitSuccess({dynamic data}) {
    emitStatus(AppStatus.success(data: data));
  }

  /// Emit a loading status
  void emitLoading({dynamic data}) {
    emitStatus(AppStatus.loading(data: data));
  }

  /// Emit an info status
  void emitInfo({dynamic data}) {
    emitStatus(AppStatus.info(data: data));
  }

  /// Emit a warning status
  void emitWarning({dynamic data}) {
    emitStatus(AppStatus.warning(data: data));
  }

  /// Emit a processing status
  void emitProcessing({dynamic data}) {
    emitStatus(AppStatus.processing(data: data));
  }

  /// Reset status of specific type
  void resetStatusType(StatusType type) {
    if (_statusByType.containsKey(type)) {
      _statusByType.remove(type);
      notifyListeners();
    }
  }

  /// Reset error status
  void resetError() {
    resetStatusType(StatusType.error);
  }

  /// Reset success status
  void resetSuccess() {
    resetStatusType(StatusType.success);
  }

  /// Reset loading status
  void resetLoading() {
    resetStatusType(StatusType.loading);
  }

  /// Reset all statuses
  void resetStatus() {
    _lastStatus = null;
    _statusByType.clear();
    notifyListeners();
  }

  /// Start loading
  void startLoading({dynamic data}) {
    emitLoading(data: data);
  }

  /// Stop loading
  void stopLoading() {
    resetLoading();
  }

  /// Convenience method to force-emit a status and then reset it after a delay
  /// Useful for transient status messages
  Future<void> emitTransientStatus(
    AppStatus status, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    emitStatus(status);
    await Future.delayed(duration);
    if (_lastStatus == status) {
      resetStatus();
    }
  }

  /// Emit a transient error
  Future<void> emitTransientError({
    Duration duration = const Duration(seconds: 3),
    dynamic data,
    ErrorType? errorType,
  }) async {
    await emitTransientStatus(
      AppStatus.error(data: data, errorType: errorType),
      duration: duration,
    );
  }

  /// Emit a transient success
  Future<void> emitTransientSuccess({
    Duration duration = const Duration(seconds: 3),
    dynamic data,
  }) async {
    await emitTransientStatus(
      AppStatus.success(data: data),
      duration: duration,
    );
  }

  /// Re-emit the last status
  void reEmitLastStatus() {
    if (_lastStatus != null) {
      _statusController.add(_lastStatus!);
    }
  }

  @override
  void dispose() {
    _statusController.close();
    super.dispose();
  }
}
