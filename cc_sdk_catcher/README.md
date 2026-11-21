# cc_sdk_catcher

Uncaught-error handling for `cc_sdk`, built on
[catcher_2](https://pub.dev/packages/catcher_2).

| Piece | Role |
|---|---|
| `CcCatcherBootstrap` | `Catcher2Options` for debug / release / profile: console (debug), the crash log file (`CcCrashLogPaths` in `cc_sdk`), the `CcCrashReporter`, and the app's remote handlers (release / profile) |
| `CcCrashReporterHandler` | Forwards each uncaught error to the `CcCrashReporter` interface of `cc_sdk` |

Setup, at boot once DI is ready:

```dart
final logFile = await CcCrashLogPaths.resolveLogFile();
Catcher2(
  rootWidget: const App(),
  debugConfig: CcCatcherBootstrap.debugOptions(logFile, crashReporter: reporter),
  releaseConfig: CcCatcherBootstrap.releaseOptions(logFile, crashReporter: reporter),
);
```

No DI registration: the package has no services, only option builders.
Apps that handle uncaught errors another way (`FlutterError.onError` +
`PlatformDispatcher.instance.onError`) skip this package and call
`CcCrashReporter.recordError` themselves.
