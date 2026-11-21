import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final spaces = <Widget, double>{
    const CcSpaceXS(): CcPaddingParams.SPACE_XS,
    const CcSpaceSM(): CcPaddingParams.SPACE_SM,
    const CcSpaceMD(): CcPaddingParams.SPACE_MD,
    const CcSpaceLG(): CcPaddingParams.SPACE_LG,
    const CcSpaceXL(): CcPaddingParams.SPACE_XL,
  };

  spaces.forEach((space, token) {
    testWidgets('${space.runtimeType} is $token dp on a 360 dp phone', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(Center(child: space));

      expect(tester.getSize(find.byWidget(space)), Size(token, token));
    });
  });

  test('tokens follow the 4 / 8 / 12 / 16 / 24 scale', () {
    expect(spaces.values, [4, 8, 12, 16, 24]);
  });
}
