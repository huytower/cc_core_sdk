# cc_sdk_slack

Slack (Incoming Webhook) implementations of `cc_sdk` capabilities. Only this
package knows about Slack; nothing in it is translated or app-specific.

| Capability | Class | Used as |
|---|---|---|
| Crash alerts | `CcSlackHandler` | Catcher2 `ReportHandler`, passed in `CcCatcherBootstrap.releaseOptions(remoteHandlers: [...])` |
| User feedback | `CcSlackFeedbackReporter` | `CcFeedbackReporter` (register it in the app's DI) |

Both take the webhook URL from the app (a secret: never commit it). Message
captions for feedback come translated from the app as `CcFeedbackLabels`.

Webhook URLs ship inside the app binary and can be extracted. For a public app,
consider a server-side proxy and implement `CcFeedbackReporter` against it.
