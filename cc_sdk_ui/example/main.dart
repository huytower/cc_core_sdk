// Minimal example of cc_sdk_ui on its own: no app module, no app theme, no
// translations. All user-facing text is passed in, colours come from the
// Material colour scheme (context.ccColorScheme), sizes from the CcScale curve.
//
// - CcAdaptiveBuilder: one column on phones, two from the expanded class on.
// - CcMaxWidth.content: full-width background, content capped at 840 dp.
// - CcCard, CcBaseBtn, CcSpace*, CcText, CcBadgeCounter.
// - LoadingPage / EmptyPage / ErrorPage driven by CcLayoutStatus.
// - CcSnackBarHelper for feedback.
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(const CcSdkUiExampleApp());

class CcSdkUiExampleApp extends StatelessWidget {
  const CcSdkUiExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cc_sdk_ui example',
      theme: ThemeData(colorSchemeSeed: CcBaseColors.infoBlue),
      home: const ExampleShowcasePage(),
    );
  }
}

class ExampleShowcasePage extends StatefulWidget {
  const ExampleShowcasePage({super.key});

  @override
  State<ExampleShowcasePage> createState() => _ExampleShowcasePageState();
}

class _ExampleShowcasePageState extends State<ExampleShowcasePage> {
  CcLayoutStatus _status = CcLayoutStatus.success;
  int _saves = 0;

  void _save() {
    setState(() => _saves++);
    CcSnackBarHelper.showSnackBar(context: context, message: 'Saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('cc_sdk_ui example')),
      body: ColoredBox(
        color: context.ccColorScheme.surfaceContainerLow,
        child: CcMaxWidth.content(
          child: CcAdaptiveBuilder(
            compact: (_) => ListView(
              padding: EdgeInsets.all(context.respPadding(16)),
              children: [_buildControls(), const CcSpaceLG(), _buildState()],
            ),
            expanded: (_) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildControls()),
                const CcSpaceLG(),
                Expanded(child: _buildState()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return CcCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(child: CcText('Saved items')),
              CcBadgeCounter(count: _saves),
            ],
          ),
          const CcSpaceMD(),
          CcBaseBtn(title: 'Save', onTap: _save),
          const CcSpaceMD(),
          SegmentedButton<CcLayoutStatus>(
            segments: const [
              ButtonSegment(
                value: CcLayoutStatus.success,
                label: Text('Content'),
              ),
              ButtonSegment(
                value: CcLayoutStatus.loading,
                label: Text('Loading'),
              ),
              ButtonSegment(value: CcLayoutStatus.empty, label: Text('Empty')),
              ButtonSegment(value: CcLayoutStatus.error, label: Text('Error')),
            ],
            selected: {_status},
            onSelectionChanged: (value) =>
                setState(() => _status = value.single),
          ),
        ],
      ),
    );
  }

  Widget _buildState() {
    final child = switch (_status) {
      CcLayoutStatus.loading || CcLayoutStatus.refresh => const LoadingPage(),
      CcLayoutStatus.empty => const EmptyPage(message: 'Nothing here yet'),
      CcLayoutStatus.error => ErrorPage(
        message: 'Something went wrong',
        onRetry: () => setState(() => _status = CcLayoutStatus.success),
      ),
      CcLayoutStatus.success || CcLayoutStatus.loadMore => const CcText(
        'Content loaded',
        align: Alignment.center,
      ),
    };
    return SizedBox(height: context.respDim(320), child: child);
  }
}
