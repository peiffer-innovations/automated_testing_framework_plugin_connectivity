# automated_testing_framework_plugin_flow_control

## Table of Contents

* [Introduction](#introduction)
* [Live Example](#live-example)
* [Quick Start](#quick-start)
* [Reserved Variables](#reserved_variables)
* [Additional Test Steps](https://github.com/peiffer-innovations/automated_testing_framework_plugin_flow_control/blob/main/documentation/STEPS.md)


## Introduction

A series of test steps that are related to test connectivity functionality.  This includes the ability to assert the device is on or offline, simulate on vs offline, as well as setting a persistent `_connected` variable that other steps can use to test against connectivity themselves.

Applications wishing to utilize this plugin should utilize the `ConnectivityPlugin` when testing for online vs offline.  That plugin class can accept either a `Stream<bool>` (say from a ping timer that actually checks an API) or directly utilize the [connectivity](https://pub.dev/packages/connectivity) to determine on / offline status.  If a stream is passed to the `initialize` function then that stream will be used otherwise the plugin will fallback to directly using the `connectivity` plugin.

The test steps provided by this library directly work with the `ConnectivityPlugin` to set overrides for test purposes.


## Live Example

* [Web](https://peiffer-innovations.github.io/automated_testing_framework_plugin_connectivity/web/#/)


## Quick Start

```dart
import 'package:automated_testing_framework_plugin_connectivity/automated_testing_framework_plugin_connectivity.dart';

void main() {
  TestConnectivityHelper.registerTestSteps();

  ...

  // You _must_ initialize the plugin, though the controller may be null in 
  // release mode which puts the plugin in "passthrough" mode rather than active
  // testable mode.
  ConnectivityPlugin().initialize(testController: testController);

  // rest of app initialization
  // ...
}
```

## Reserved Variables

The following table defines the reserved variables provided by the plugin that can be by appropriate tests:

Name            | Type      | Example | Description
----------------|-----------|---------|-------------
`_connected`    | `boolean` | true    | Will be `true` when the application considers itself online and `false` when the application consider itself offline.
