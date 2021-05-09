import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_connectivity/automated_testing_framework_plugin_connectivity.dart';
import 'package:json_class/json_class.dart';

/// Set's the device's connectivity status.  As a note, this will not actually
/// change the connection.  Instead, it sets the value on the
/// [ConnectivityPlugin].  Applications would need to use that plugin to allow
/// for connectivity testing.
class SetConnectivityStep extends TestRunnerStep {
  SetConnectivityStep({
    required this.connected,
  }) : assert(connected.isNotEmpty == true);

  static const id = 'set_connectivity';

  static List<String> get behaviorDrivenDescriptions => List.unmodifiable([
        "set the device's connectivity override to `{{connected}}`.",
      ]);

  /// Set to whether or not the device should be forced to report as being
  /// online (`true`) or offline (`false`).
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
  static SetConnectivityStep fromDynamic(dynamic map) {
    SetConnectivityStep result;

    if (map == null) {
      throw Exception('[SetConnectivityStep.fromDynamic]: map is null');
    } else {
      result = SetConnectivityStep(
        connected: map['connected']!.toString(),
      );
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
    var connected =
        tester.resolveVariable(this.connected)?.toString().toLowerCase();

    assert(['false', 'true'].contains(connected));
    var name = "set_connectivity('$connected')";

    log(
      name,
      tester: tester,
    );

    ConnectivityPlugin().overriddenConnected = JsonClass.parseBool(connected);
  }

  @override
  String getBehaviorDrivenDescription() {
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
  Map<String, dynamic> toJson() => {
        'connected': connected,
      };
}
