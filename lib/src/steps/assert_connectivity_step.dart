import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_connectivity/automated_testing_framework_plugin_connectivity.dart';
import 'package:json_class/json_class.dart';

/// Test step that asserts that the value within [variableName] equals (or does
/// not equal) a specific [value].
class AssertConnectivityStep extends TestRunnerStep {
  AssertConnectivityStep({
    required this.connected,
  }) : assert(connected.isNotEmpty == true);

  static const id = 'assert_connectivity';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        'assert that the device is `{{connected}}`.',
      ]);

  /// Set to [true] to expect the application is set as being connected to the
  /// internet and [false] otherwise.
  final String connected;

  @override
  String get stepId => id;

  /// Creates an instance from a JSON-like map structure.  This expects the
  /// following format:
  ///
  /// ```json
  /// {
  ///   "connected": <bool>
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

  @override
  String getBehaviorDrivenDescription(TestController tester) {
    var result = behaviorDrivenDescriptions[0];

    if (connected.contains('{{')) {
      result = result.replaceAll('{{connected}}', connected);
    } else {
      result = result.replaceAll(
        '{{connected}}',
        JsonClass.parseBool(connected) == true ? 'online' : 'offline',
      );
    }

    return result;
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
