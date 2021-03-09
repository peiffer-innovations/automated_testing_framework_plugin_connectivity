import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_connectivity/automated_testing_framework_plugin_connectivity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('', () {});

  test('assert_connectivity', () {
    TestConnectivityHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'assert_connectivity',
    )!;

    expect(availStep.form.runtimeType, AssertConnectivityForm);
    expect(
      availStep.help,
      TestConnectivityTranslations.atf_connectivity_help_assert_connectivity,
    );
    expect(availStep.id, 'assert_connectivity');
    expect(
      availStep.title,
      TestConnectivityTranslations.atf_connectivity_title_assert_connectivity,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('reset_connectivity', () {
    TestConnectivityHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'reset_connectivity',
    )!;

    expect(availStep.form.runtimeType, ResetConnectivityForm);
    expect(
      availStep.help,
      TestConnectivityTranslations.atf_connectivity_help_reset_connectivity,
    );
    expect(availStep.id, 'reset_connectivity');
    expect(
      availStep.title,
      TestConnectivityTranslations.atf_connectivity_title_reset_connectivity,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });

  test('set_connectivity', () {
    TestConnectivityHelper.registerTestSteps();
    var availStep = TestStepRegistry.instance.getAvailableTestStep(
      'set_connectivity',
    )!;

    expect(availStep.form.runtimeType, SetConnectivityForm);
    expect(
      availStep.help,
      TestConnectivityTranslations.atf_connectivity_help_set_connectivity,
    );
    expect(availStep.id, 'set_connectivity');
    expect(
      availStep.title,
      TestConnectivityTranslations.atf_connectivity_title_set_connectivity,
    );
    expect(availStep.type, null);
    expect(availStep.widgetless, true);
  });
}
