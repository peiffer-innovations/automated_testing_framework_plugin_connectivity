import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_connectivity/automated_testing_framework_plugin_connectivity.dart';

/// Set's the device's connectivity status.  As a note, this will not actually
/// change the connection.  Instead, it sets the value on the
/// [ConnectivityPlugin].  Applications would need to use that plugin to allow
/// for connectivity testing.
class ResetConnectivityStep extends TestRunnerStep {
  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "connectivity": <String>
  /// }
  /// ```
  static ResetConnectivityStep fromDynamic(dynamic map) {
    ResetConnectivityStep result;

    if (map == null) {
      throw Exception('[ResetConnectivityStep.fromDynamic]: map is null');
    } else {
      result = ResetConnectivityStep();
    }

    return result;
  }

  /// Sets the connectivity value to the [ConnectivityPlugin].
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    var name = 'reset_connectivity()';

    log(
      name,
      tester: tester,
    );

    ConnectivityPlugin().overriddenConnected == null;
  }

  /// Overidden to ignore the delay
  @override
  Future<void> preStepSleep(Duration duration) async {}

  /// Overidden to ignore the delay
  @override
  Future<void> postStepSleep(Duration duration) async {}

  /// Converts this to a JSON compatible map.  For a description of the format,
  /// see [fromDynamic].
  @override
  Map<String, dynamic> toJson() => {};
}
