import 'dart:async';

import 'package:flutter/foundation.dart';

/// A generic mixin that provides status handling and event listening functionality using Streams
/// Can be used by any model that extends ChangeNotifier
mixin StatusStreamMixin<T> on ChangeNotifier {
  /// Stream controller for status events
  final _statusController = StreamController<T>.broadcast();

  /// Last emitted status, stored for sync access
  T? _lastStatus;

  /// Public stream of status events
  Stream<T> get statusStream => _statusController.stream;

  /// Get current status
  T? get currentStatus => _lastStatus;

  /// Subscribe to status events
  /// Returns a subscription that can be used to cancel the listener
  StreamSubscription<T> addStatusListener(void Function(T status) listener) {
    return _statusController.stream.listen(listener);
  }

  /// Emit a status event and notify listeners
  void emitStatus(T status) {
    _lastStatus = status;
    _statusController.add(status);
    notifyListeners();
  }

  /// Emit the same status again, even if the status hasn't changed
  /// This is useful when you want to trigger the same status multiple times
  void reEmitLastStatus() {
    final lastStatus = _lastStatus;
    if (lastStatus != null) {
      _statusController.add(lastStatus);
      notifyListeners();
    }
  }

  /// Reset the status state
  void resetStatus() {
    _lastStatus = null;
    notifyListeners();
  }

  /// Convenience method to force-emit a status and then reset it after a delay
  /// Useful for transient status messages
  Future<void> emitTransientStatus(T status,
      {Duration duration = const Duration(seconds: 3)}) async {
    emitStatus(status);
    await Future.delayed(duration);
    resetStatus();
  }

  @override
  void dispose() {
    _statusController.close();
    super.dispose();
  }
}
