import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_connectivity/automated_testing_framework_plugin_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:static_translations/static_translations.dart';

class SetConnectivityForm extends TestStepForm {
  const SetConnectivityForm();

  @override
  bool get supportsMinified => true;

  @override
  TranslationEntry get title =>
      TestConnectivityTranslations.atf_connectivity_title_set_connectivity;

  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic>? values, {
    bool minify = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (minify != true)
          buildHelpSection(
            context,
            TestConnectivityTranslations.atf_connectivity_help_set_connectivity,
            minify: minify,
          ),
        buildValuesSection(
          context,
          [
            buildDropdown(
              context: context,
              defaultValue: 'false',
              id: 'connected',
              items: [
                'false',
                'true',
              ],
              label:
                  TestConnectivityTranslations.atf_connectivity_form_connected,
              values: values ?? <String, dynamic>{},
            ),
          ],
          minify: minify,
        ),
      ],
    );
  }
}
