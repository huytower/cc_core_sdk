import 'package:app_config/core/enum/environment.dart';

import 'core/runner/environment_runner.dart';

/// FOR FREE_FAKE_API ENV. ONLY
/// when server already support UAT|PROD, skip this file
void main() {
  EnvironmentRunner.run(Environment.FREE_FAKE_API, disableSsl: true);
}
