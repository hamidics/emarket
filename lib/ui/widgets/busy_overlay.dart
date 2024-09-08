/*
  
 */

import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BusyOverlay extends StatelessWidget {
  final Widget child;
  final bool show;
  const BusyOverlay({Key key, this.child, this.show = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return Material(
      child: Stack(
        children: [
          child,
          IgnorePointer(
            child: Opacity(
              opacity: show ? 1 : 0,
              child: Container(
                width: screenSize.width,
                height: screenSize.height,
                alignment: Alignment.center,
                color: Colors.white70,
                child: SpinKitRing(color: ThemeColors.Orange),
              ),
            ),
          )
        ],
      ),
    );
  }
}
