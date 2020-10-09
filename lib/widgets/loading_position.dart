import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingPosition extends StatelessWidget {
  final bool isLoading;

  const LoadingPosition({Key key, this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(200)),
      child: Align(
        alignment: FractionalOffset(0.5, 0.5),
        child: CupertinoActivityIndicator(
          radius: 25.0,
          animating: isLoading,
        ),
      ),
    );
  }
}
