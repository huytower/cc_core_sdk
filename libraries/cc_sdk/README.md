# CC SDK Core

A core SDK package that provides essential functionality and utilities for Flutter applications. This package is part of a larger ecosystem that includes `cc_sdk_ui` for UI components.

## Features

- **Core Functionality**
  - Network utilities (CURL, interceptors)
  - Device information
  - Common extensions and helpers
  - Serialization (GSON)
  - Error handling and failure management

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  cc_sdk:
    path: ../path/to/cc_sdk
  cc_sdk_ui:  # For UI components
    path: ../path/to/cc_sdk_ui
```

## Usage

### Core Functionality

```dart
import 'package:cc_sdk/core/network/network_info.dart';
import 'package:cc_sdk/core/utils/common/device_utils.dart';

// Check network connectivity
```
final isConnected = await NetworkInfo().isConnected;
```

// Get device info
```
final deviceInfo = await DeviceUtils.getDeviceInfo();
```

### Error Handling

```dart
import 'package:cc_sdk/core/exception/error/failure.dart';

class MyUseCase {
  Future<Result<MyData, Failure>> getData() async {
    try {
      // Your implementation
      return Success(data);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
```

## Dependencies

- `connectivity_plus`: For network status monitoring
- `dio`: For HTTP requests
- `device_info_plus`: For device information
- `crypto`: For hashing utilities
- `equatable`: For value equality
- `google_fonts`: For text styling
- `intl`: For internationalization
- `multiple_result`: For better error handling
- `package_info_plus`: For app package information

NOTICE that :
``
a. Distribution : Everytime distribute latest source code to sub-project, MUST increase version in `pubspec.yaml`

    b. If there are duplicated|oldest `cc_library` module in section `Dart Packages` (at Project tab)
    
        Sometimes it happens when IDE can not know where is latest version.
        
        Try to get latest version by using :
    
        * Solution 1 :

            - MUST run `flutter clean` in module `widget` & `root` project
    
            - MUST invalidate & restart IDE (if has)
            
            - MUST `flutter pub cache clean` to clean old version

            - MUST `flutter pub upgrade` in module `widget` & `root` project, to get latest version

            - MUST `flutter pub get` in module `widget` & `root` project

        * Solution 2 : (FAST STEP)

            - Guarantee commit|push all code

            - Delete current project

            - Then get latest project by using `git clone https://coc.mobile.erp.git`

            at : https://coc.mobile.erp/src/master/

            - Switch to correct branch, ex. `master`.v.v