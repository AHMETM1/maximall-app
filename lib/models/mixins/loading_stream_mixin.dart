/// A mixin that provides loading state handling and event listening functionality
/// Can be used by any model that extends ChangeNotifier
import 'dart:async';

import 'package:flutter/material.dart';

typedef LoadingListener = void Function(bool isLoading);

mixin LoadingStreamMixin on ChangeNotifier {
  final _loadingController = StreamController<bool>.broadcast()..add(false);
  bool _isLoading = false;

  /// Get current loading state
  bool get isLoading => _isLoading;

  /// Get the loading stream
  Stream<bool> get loadingStream => _loadingController.stream;

  /// Register a listener to be notified of loading state changes
  StreamSubscription<bool> addLoadingListener(LoadingListener listener) {
    return loadingStream.listen(listener);
  }

  /// Set loading state and notify listeners
  void setLoading(bool loading) {
    _isLoading = loading;
    _loadingController.add(loading);
    notifyListeners();
  }

  /// Helper method to start loading and notify listeners
  void startLoading() {
    setLoading(true);
  }

  /// Helper method to stop loading and notify listeners
  void stopLoading() {
    setLoading(false);
  }

  @override
  void dispose() {
    _loadingController.close();
    super.dispose();
  }
}
