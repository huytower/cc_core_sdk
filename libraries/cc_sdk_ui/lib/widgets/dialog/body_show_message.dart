import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/button/cc_debounce_widget.dart';
import '../../widgets/space/cc_space.dart';

class BodyShowMessage extends StatelessWidget {
  final Widget child;
  final String title;
  final String content;
  final VoidCallback? onTabOK;
  final bool isExistOK;

  const BodyShowMessage({
    Key? key,
    required this.child,
    this.content = '',
    this.title = '',
    this.onTabOK,
    this.isExistOK = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    height: 235,
    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
    child: Column(
      children: [
        const CcSpaceLG(),
        const CcSpaceLG(),
        title.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(bottom: 20, top: 10),
                child: Text(title, style: const TextStyle(fontSize: 24)),
              )
            : const SizedBox(),
        child,
        const CcSpaceLG(),
        const CcSpaceLG(),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              !isExistOK
                  ? Expanded(
                      child: CcDebounce(
                        onTap: () => Get.back(),
                        iconColor: Colors.pink,
                        textColor: Colors.white,
                        title: 'Cancel',
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: CcDebounce(
                  onTap: onTabOK,
                  iconColor: Colors.pink,
                  textColor: Colors.white,
                  title: 'OK',
                ),
              ),
            ],
          ),
        ),
        const CcSpaceSM(),
      ],
    ),
  );
}
