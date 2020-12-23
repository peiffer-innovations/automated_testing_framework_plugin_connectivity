import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_connectivity/automated_testing_framework_plugin_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:static_translations/static_translations.dart';

class ResetConnectivityForm extends TestStepForm {
  const ResetConnectivityForm();

  @override
  bool get supportsMinified => false;

  @override
  TranslationEntry get title =>
      TestConnectivityTranslations.atf_connectivity_title_reset_connectivity;

  @override
  Widget buildForm(
    BuildContext context,
    Map<String, dynamic> values, {
    bool minify = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildHelpSection(
          context,
          TestConnectivityTranslations.atf_connectivity_help_reset_connectivity,
          minify: minify,
        ),
      ],
    );
  }
}
