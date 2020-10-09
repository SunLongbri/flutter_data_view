import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RotateView extends StatefulWidget {
  final String icon;
  final bool onShow;
  final int speed;

  RotateView({this.icon, this.onShow, this.speed});

  @override
  _RotateViewState createState() => _RotateViewState();
}

class _RotateViewState extends State<RotateView> {
  double rotation = 0.0;

  @override
  void dispose() {
    super.dispose();
    if(timer != null){
      timer.cancel();
    }
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.onShow) {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
      return Container(
        width: ScreenUtil().setWidth(96),
        child: Image.asset(widget.icon),
      );
    }
    _timer();
    return Transform.rotate(
        child: Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(96),
          child: Image.asset(widget.icon),
        ),
        angle: rotation);
  }

  Timer timer;

  _timer() async {
    if (timer == null) {
      timer = Timer.periodic(Duration(milliseconds: widget.speed ?? 100), (as) {
        print(rotation);
        rotation = rotation + 1.0;
        setState(() {});
      });
    }
  }
}
