import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_connectivity/automated_testing_framework_plugin_connectivity.dart';

class TestConnectivityHelper {
  /// Registers the test steps to the optional [registry].  If not set, the
  /// default [TestStepRegistry] will be used.
  static void registerTestSteps([TestStepRegistry? registry]) {
    (registry ?? TestStepRegistry.instance).registerCustomSteps([
      TestStepBuilder(
        availableTestStep: const AvailableTestStep(
          form: AssertConnectivityForm(),
          help: TestConnectivityTranslations
              .atf_connectivity_help_assert_connectivity,
          id: AssertConnectivityStep.id,
          keys: {'connected'},
          quickAddValues: {'connected': 'false'},
          title: TestConnectivityTranslations
              .atf_connectivity_title_assert_connectivity,
          widgetless: true,
          type: null,
        ),
        testRunnerStepBuilder: AssertConnectivityStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: const AvailableTestStep(
          form: ResetConnectivityForm(),
          help: TestConnectivityTranslations
              .atf_connectivity_help_reset_connectivity,
          id: ResetConnectivityStep.id,
          keys: {},
          quickAddValues: {},
          title: TestConnectivityTranslations
              .atf_connectivity_title_reset_connectivity,
          widgetless: true,
          type: null,
        ),
        testRunnerStepBuilder: ResetConnectivityStep.fromDynamic,
      ),
      TestStepBuilder(
        availableTestStep: const AvailableTestStep(
          form: SetConnectivityForm(),
          help: TestConnectivityTranslations
              .atf_connectivity_help_set_connectivity,
          id: SetConnectivityStep.id,
          keys: {'connected'},
          quickAddValues: null,
          title: TestConnectivityTranslations
              .atf_connectivity_title_set_connectivity,
          widgetless: true,
          type: null,
        ),
        testRunnerStepBuilder: SetConnectivityStep.fromDynamic,
      ),
    ]);
  }
}
