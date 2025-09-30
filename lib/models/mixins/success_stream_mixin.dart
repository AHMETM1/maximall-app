import 'dart:async';

import 'package:flutter/foundation.dart';

import 'status_stream_mixin.dart';

/// Success message data structure
class SuccessKey {
  final String value;

  /// Create a success key with a custom message
  const SuccessKey.custom(this.value);

  /// Create a predefined success key
  const SuccessKey(this.value);

  @override
  String toString() => value;
}

/// Listener definition for success events
typedef SuccessListener = void Function(SuccessKey successMsg);

/// A mixin that provides success handling and event listening functionality using Streams
/// Can be used by any model that extends ChangeNotifier
mixin SuccessStreamMixin on ChangeNotifier, StatusStreamMixin<SuccessKey> {
  /// Public stream of success events
  Stream<SuccessKey> get successStream => statusStream;

  /// Get current success message
  String? get successMessage => currentStatus?.value;

  /// Get current success key
  SuccessKey? get successKey => currentStatus;

  /// Subscribe to success events
  /// Returns a subscription that can be used to cancel the listener
  StreamSubscription<SuccessKey> addSuccessListener(SuccessListener listener) {
    return addStatusListener(listener);
  }

  /// Helper method to emit a success message and notify listeners
  void emitSuccessMessage(String message) {
    final customSuccessKey = SuccessKey.custom(message);
    emitStatus(customSuccessKey);
  }

  /// Emit a success event using a success key for localization
  /// This should be used instead of emitSuccessMessage for proper localization
  void emitSuccess(SuccessKey successKey, {String? rawMessage}) {
    emitStatus(successKey);
  }

  /// Emit the same success again, even if the success key hasn't changed
  /// This is useful when you want to trigger the same success multiple times
  void reEmitLastSuccess() {
    reEmitLastStatus();
  }

  /// Reset the success state
  void resetSuccess() {
    resetStatus();
  }

  /// Convenience method to force-emit a success and then reset it after a delay
  /// Useful for transient success messages
  Future<void> emitTransientSuccess(SuccessKey successKey,
      {Duration duration = const Duration(seconds: 3)}) async {
    await emitTransientStatus(successKey, duration: duration);
  }
}
