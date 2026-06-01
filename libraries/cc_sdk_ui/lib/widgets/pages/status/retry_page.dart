import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:message/cc_locale_keys.dart';

/// Retry page displayed when an action fails and can be retried.
/// Shows a retry button to attempt the action again.
class RetryPage extends StatelessWidget {
  const RetryPage({
    Key? key,
    this.message = 'Something went wrong',
    this.onRetry,
  }) : super(key: key);

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(el.tr(CcLocaleKeys.app_error_retry)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
