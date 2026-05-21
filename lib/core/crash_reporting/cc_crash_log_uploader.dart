import 'dart:developer' as developer;

import 'package:app_config/core/config/app/cc_app_track_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'cc_crash_log_paths.dart';

/// Uploads the local crash log file to the backend on cold start.
abstract final class CcCrashLogUploader {
  CcCrashLogUploader._();

  static bool get _isUploadEnabled {
    final raw = dotenv.maybeGet('ENABLE_CRASH_LOG_UPLOAD', fallback: 'true');
    return raw?.toLowerCase() != 'false';
  }

  static Uri? _resolveEndpoint() {
    final base = dotenv.maybeGet('API_URL');
    if (base == null || base.isEmpty) return null;
    final path = dotenv.maybeGet('CRASH_LOG_API_PATH', fallback: '/client-logs');
    return Uri.parse(base).resolve(path ?? '/client-logs');
  }

  /// POSTs pending file logs from a previous session, then clears the file on success.
  static Future<void> uploadPendingOnRestart() async {
    if (!_isUploadEnabled) return;

    final endpoint = _resolveEndpoint();
    if (endpoint == null) {
      developer.log('Crash log upload skipped: API_URL not set', name: 'CrashLog');
      return;
    }

    final file = await CcCrashLogPaths.resolveLogFile();
    if (!file.existsSync() || file.lengthSync() == 0) return;

    final logs = await file.readAsString();
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    try {
      final response = await dio.post<Map<String, dynamic>>(
        endpoint.toString(),
        data: {
          'appName': CcAppTrackName.appName,
          'uploadedAt': DateTime.now().toUtc().toIso8601String(),
          'logs': logs,
        },
      );
      final code = response.statusCode ?? 0;
      if (code >= 200 && code < 300) {
        await CcCrashLogPaths.clearLogFile();
        developer.log('Crash log uploaded (${logs.length} chars)', name: 'CrashLog');
      }
    } on DioException catch (e, stackTrace) {
      developer.log(
        'Crash log upload failed: ${e.message}',
        error: e,
        stackTrace: stackTrace,
        name: 'CrashLog',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Crash log upload failed: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'CrashLog',
      );
    }
  }
}
