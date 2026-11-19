# cc_sdk_device

Device-capability implementations of `cc_sdk` interfaces. This is the one place
that imports the device plugins they need.

| Interface (`cc_sdk`) | Implementation | Plugin |
|---|---|---|
| `CcSpeechRecognizer` | `CcSpeechToTextRecognizer` | `speech_to_text` |

## Setup

1. Add `cc_sdk_device` (path dependency) to the app.
2. Add `ExternalModule(CcSdkDevicePackageModule)` to the app's
   `externalPackageModulesBefore` (import
   `package:cc_sdk_device/core/di/di.module.dart`).
3. Inject the interface (e.g. `CcSpeechRecognizer`) where it is needed.

Platform setup (microphone / speech permissions in `AndroidManifest.xml` and
`Info.plist`) stays in the app.
