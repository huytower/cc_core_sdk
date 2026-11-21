/// Slack (Incoming Webhook) implementations of cc_sdk capabilities.
///
/// The app constructs them with its webhook URLs (secrets, never in code):
/// `CcSlackHandler` for Catcher2 crash alerts, `CcSlackCrashReporter` as a
/// `CcCrashReporter` (caught and uncaught errors), `CcSlackFeedbackReporter` as
/// the `CcFeedbackReporter`.
library;

export 'package:cc_sdk_slack/src/cc_slack_crash_reporter.dart';
export 'package:cc_sdk_slack/src/cc_slack_feedback_reporter.dart';
export 'package:cc_sdk_slack/src/cc_slack_handler.dart';
