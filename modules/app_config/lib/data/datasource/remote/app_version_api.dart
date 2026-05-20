import 'package:package_info_plus/package_info_plus.dart';

/// Service class to handle app version related operations
class AppVersionAPI {
  /// Gets the current app version from the package info
  ///
  /// Returns a Future that completes with the current app version in format: x.y.z+hotfix
  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Compares the current app version with a provided version
  ///
  /// [versionToCompare] - The version to compare with (format: x.y.z+hotfix)
  /// Returns:
  ///   - 0 if versions are equal
  ///   - negative if current version is older than [versionToCompare]
  ///   - positive if current version is newer than [versionToCompare]
  Future<int> compareVersion(String versionToCompare) async {
    final currentVersion = await getCurrentVersion();
    return _compareVersionStrings(currentVersion, versionToCompare);
  }

  /// Helper method to compare two version strings
  int _compareVersionStrings(String version1, String version2) {
    // Split version strings into parts
    final v1Parts = version1.split(RegExp(r'[.+\-]'));
    final v2Parts = version2.split(RegExp(r'[.+\-]'));

    // Convert all parts to integers for comparison
    for (var i = 0; i < v1Parts.length || i < v2Parts.length; i++) {
      final v1Part = i < v1Parts.length ? int.tryParse(v1Parts[i]) ?? 0 : 0;
      final v2Part = i < v2Parts.length ? int.tryParse(v2Parts[i]) ?? 0 : 0;

      if (v1Part < v2Part) return -1;
      if (v1Part > v2Part) return 1;
    }

    return 0; // versions are equal
  }

  /// Checks if the app needs to be updated
  ///
  /// [minRequiredVersion] - The minimum required version (format: x.y.z+hotfix)
  /// Returns true if the current version is older than the minimum required version
  Future<bool> isUpdateRequired(String minRequiredVersion) async {
    try {
      final comparison = await compareVersion(minRequiredVersion);
      return comparison < 0; // Current version is older than required
    } catch (e) {
      // In case of any parsing error, assume update is not required
      return false;
    }
  }

  /// Gets the app's build number
  ///
  /// Returns a Future that completes with the build number as a string
  Future<String> getBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  /// Gets the app's package name
  ///
  /// Returns a Future that completes with the package name
  Future<String> getPackageName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  /// Checks if the current version is a pre-release version
  ///
  /// Returns true if the current version contains pre-release identifiers (e.g., 1.0.0-beta)
  Future<bool> isPreRelease() async {
    final currentVersion = await getCurrentVersion();
    // Check for common pre-release indicators like -alpha, -beta, -rc, etc.
    return currentVersion.contains('-');
  }
}
