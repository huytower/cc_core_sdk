import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme/data/data_source/color/prj_color.dart';

class wLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(const Radius.circular(7.0)),
            color: PrjColors.outlineVariant,
          ),
          height: 50,
          width: 50,
          child: CupertinoActivityIndicator(radius: 12),
        ),
      ),
    );
  }
}
