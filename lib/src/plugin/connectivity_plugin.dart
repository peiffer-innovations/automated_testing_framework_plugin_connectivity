import 'dart:async';

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

/// Plugin that allows for the simulation of being connected or disconnected
/// from internet for automated connectivity testing without having to actually
/// enable / disable the entire phone's connection.
///
/// As a note, this won't actually change the real device's connectivity.  So
/// users of this plugin must utilize it for all connectivity checks or
/// unexpected results may be encountered.
///
///
///
/// This is a singleton.  All "new" instances are the same object reference.
class ConnectivityPlugin with WidgetsBindingObserver {
  factory ConnectivityPlugin() => _singleton;
  ConnectivityPlugin._internal();

  static final ConnectivityPlugin _singleton = ConnectivityPlugin._internal();

  StreamController<bool> _connectedStreamController =
      StreamController<bool>.broadcast();
  Connectivity _connectivity;
  StreamSubscription _connectivitySubscription;
  bool _currentConnected;
  bool _initialized = false;
  bool _overriddenConnected;
  TestController _testController;

  /// Returns whether or not the device is currently connected.
  bool get connected => _currentConnected;

  /// Returns the overridden connection type.  If the connection type has not
  /// been overridden then this will return [null].
  bool get overriddenConnected => _overriddenConnected;

  /// Sets the overridden connected state.  Set to [null] to reset back to using
  /// the value from the device.
  set overriddenConnected(bool connected) {
    if (_testController == null && connected != null) {
      throw Exception(
        'The connected flag may not be overridden unless the plugin was initialized with a TestController.',
      );
    }
    _overriddenConnected = connected;
    refresh();
  }

  /// Called by the framework when the application launch state changes.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  /// Disposes the plugin, stops all streams, and stops all listeners.  Once
  /// disposed, this plugin cannot be used again until the application fully
  /// restarts.
  void dispose() {
    _connectivity = null;

    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    _connectedStreamController?.close();
    _connectedStreamController = null;

    _testController = null;
  }

  /// Initializes the plugin with an optional [TestController].  If the
  /// [TestController] is not set then this acts as nothing more than a wrapper
  /// to
  Future<void> initialize({
    Stream<bool> connectedStream,
    TestController testController,
  }) async {
    if (_initialized != true) {
      _testController = testController;
      _initialized = true;

      if (connectedStream != null) {
        _connectivitySubscription = connectedStream.listen(
          (connected) => _updateData(connected),
        );
      } else {
        _connectivity =
            Connectivity(); // Try to set up the listener, but don't blow up the app just because the
        // listener can't be registered (ie: we're on an unsupported platform).
        runZonedGuarded(() {
          _connectivitySubscription =
              _connectivity.onConnectivityChanged.listen(
            (ConnectivityResult result) => _updateData(_getConnected(result)),
          );
        }, (_, __) {
          // no-op
        });
      }
      await refresh();
    }
  }

  /// Refreshes the connectivity.  It's typically better to listen to the
  /// stream, but for one off checks, app start, or app restart, it is good to
  /// manually refresh as well.
  Future<bool> refresh() async =>
      _updateData(_getConnected(await _getConnectivityResult()));

  bool _getConnected(ConnectivityResult result) {
    bool connected;
    switch (result) {
      case ConnectivityResult.mobile:
        connected = true;
        break;
      case ConnectivityResult.none:
        connected = false;
        break;
      case ConnectivityResult.wifi:
        connected = true;
        break;
      default:
        connected = true;
        break;
    }

    return connected;
  }

  /// Gets the connectivity.  This will return the overridden value if it is
  /// set.  Otherwise, this will utilize the [Connectivity] plugin.  If there is
  /// an error getting the connectivity, this will assume the plugin is
  /// unsupported and default to [wifi].
  Future<ConnectivityResult> _getConnectivityResult() async {
    var result = await runZonedGuarded<Future<ConnectivityResult>>(
      () => _connectivity.checkConnectivity(),
      (_, __) {
        // no-op
      },
    );

    result ??= ConnectivityResult.wifi;

    return result;
  }

  bool _updateData(bool connected) {
    var realConnected = _overriddenConnected ?? connected;

    if (realConnected != _currentConnected) {
      _currentConnected = realConnected;
      _connectedStreamController?.add(_currentConnected);
      _testController?.setVariable(
        value: _currentConnected,
        variableName: '_connected',
      );
    }

    return realConnected;
  }
}
