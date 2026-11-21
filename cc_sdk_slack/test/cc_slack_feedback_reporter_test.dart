import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_slack/export_cc_sdk_slack.dart';
import 'package:flutter_test/flutter_test.dart';

const _vi = CcFeedbackLabels(
  title: 'Góp ý',
  rating: 'Đánh giá',
  praise: 'Khen',
  criticism: 'Chê',
  text: 'Nội dung',
  none: '(không có)',
  noText: '(chưa nhập)',
  notRated: '(chưa đánh giá)',
);

void main() {
  test('formats rating, tags and text with the given labels', () {
    final message = CcSlackFeedbackReporter.format(
      const CcFeedback(
        text: ' Hay quá ',
        praise: ['Nhanh', 'Gọn'],
        rating: 4.25,
      ),
      _vi,
    );

    expect(
      message,
      '*Góp ý*\n'
      '*Đánh giá:* ⭐ 4.3/5\n'
      '*Khen:* Nhanh, Gọn\n'
      '*Chê:* (không có)\n'
      '*Nội dung:* Hay quá',
    );
  });

  test('uses the empty-state labels', () {
    final message = CcSlackFeedbackReporter.format(
      const CcFeedback(text: '  '),
      _vi,
    );

    expect(message, contains('*Đánh giá:* (chưa đánh giá)'));
    expect(message, contains('*Nội dung:* (chưa nhập)'));
  });

  test('does not send without a webhook URL', () async {
    final reporter = CcSlackFeedbackReporter(webhookUrl: '  ');
    expect(await reporter.send(const CcFeedback(text: 'x')), isFalse);
  });

  test('crash handler without a webhook URL reports nothing', () {
    expect(() => CcSlackHandler(webhookUrl: ''), returnsNormally);
  });
}
