# cc_sdk_phone

Per-country phone number rules for `cc_sdk`.

| Interface (`cc_sdk`) | Implementation | Library |
|---|---|---|
| `CcPhoneNumberValidator` | `CcLibPhoneNumberValidator` | `phone_numbers_parser` |

Setup: add `ExternalModule(CcSdkPhonePackageModule)` (import
`package:cc_sdk_phone/core/di/di.module.dart`) to the app's
`externalPackageModulesBefore`, then inject `CcPhoneNumberValidator`.

Apps that do not need per-country rules can skip this package and register
`CcBasicPhoneNumberValidator` (E.164 shape only) from `cc_sdk`. The phone
input widgets (`CcPhoneNumberInput`, `CcCountryCodeSelector`) live in
`cc_sdk_ui` and need neither.
