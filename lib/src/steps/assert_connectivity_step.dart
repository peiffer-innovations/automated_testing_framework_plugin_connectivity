import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_connectivity/automated_testing_framework_plugin_connectivity.dart';
import 'package:json_class/json_class.dart';

/// Test step that asserts that the value within [variableName] equals (or does
/// not equal) a specific [value].
class AssertConnectivityStep extends TestRunnerStep {
  AssertConnectivityStep({
    required this.connected,
  }) : assert(connected.isNotEmpty == true);

  /// Set to [true] to expect the application is set as being connected to the
  /// internet and [false] otherwise.
  final String connected;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "connected": <bool>,
  ///   "connectivity": <String>
  /// }
  /// ```
  ///
  /// See also:
  /// * [JsonClass.parseBool]
  static AssertConnectivityStep fromDynamic(dynamic map) {
    AssertConnectivityStep result;

    if (map == null) {
      throw Exception('[AssertConnectivityStep.fromDynamic]: map is null');
    } else {
      result = AssertConnectivityStep(
        connected: map['connected']!.toString().toLowerCase(),
      );
    }

    return result;
  }

  /// Executes the step.  This will
  @override
  Future<void> execute({
    required CancelToken cancelToken,
    required TestReport report,
    required TestController tester,
  }) async {
    var connected = tester.resolveVariable('{{_connected}}');
    var name = "assert_connectivity('${connected}')";
    log(
      name,
      tester: tester,
    );

    connected = connected == null ? null : JsonClass.parseBool(connected);

    if (connected != ConnectivityPlugin().connected) {
      throw Exception(
        'connected: actualValue: [${ConnectivityPlugin().connected}], expected: [$connected].',
      );
    }
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
  Map<String, dynamic> toJson() => {'connected': connected};
}
