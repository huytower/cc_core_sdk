import 'dart:convert';
import 'dart:io';

import 'package:cc_sdk/export_cc_sdk.dart';

/// Posts plain-text messages to one Slack Incoming Webhook.
///
/// The URL is a secret (anyone with it can post to the channel): it is only
/// ever logged masked.
class CcSlackWebhook {
  CcSlackWebhook(String rawUrl, {required this.logTag}) : url = _clean(rawUrl);

  final String url;
  final String logTag;

  bool get hasConfigured => url.isNotEmpty;

  /// Host and a short tail only, for logs.
  String get maskedUrl {
    final uri = Uri.tryParse(url);
    final tail = url.length > 4 ? url.substring(url.length - 4) : '';
    return '${uri?.host ?? '?'}/…$tail (length=${url.length})';
  }

  /// Posts [text]; `true` on HTTP 200. Never throws.
  Future<bool> post(String text) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      '❌ Invalid Slack webhook URL: $maskedUrl'.Log(logTag);
      return false;
    }
    '📤 Posting to Slack webhook $maskedUrl'.Log(logTag);

    final client = HttpClient();
    try {
      final request = await client.postUrl(uri);
      request.headers.set('content-type', 'application/json; charset=utf-8');
      request.headers.set(
        'user-agent',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      );
      request.write(jsonEncode({'text': text}));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      '✅ Slack responded ${response.statusCode}: "$body"'.Log(logTag);
      return response.statusCode == 200;
    } catch (e) {
      '❌ Slack post failed: $e'.Log(logTag);
      return false;
    } finally {
      client.close();
    }
  }

  /// Strips whitespace and surrounding quotes left by env tooling.
  static String _clean(String raw) {
    var url = raw.trim();
    if ((url.startsWith('"') && url.endsWith('"')) ||
        (url.startsWith("'") && url.endsWith("'"))) {
      url = url.substring(1, url.length - 1).trim();
    }
    return url;
  }
}
