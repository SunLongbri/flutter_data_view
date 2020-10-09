import 'dart:ui';
import 'package:flutter/widgets.dart';

enum Aspect {
  /// 宽适配
  aspectWidth,

  /// 高适配
  aspectHeight
}

class AutoLayout {
  static AutoLayout instance = new AutoLayout();

  static AutoLayout covert() => instance;

  /// 设计稿的宽
  int designWidth;

  /// 设计稿的高
  int designHeight;

  /// 设计稿的像素密度
  double designDevicePixelRatio;

  /// 适配方式
  Aspect aspect;

  ///字体是否跟随系统缩放
  bool allowFontScaling;

  /// 物理设备的宽
  static double _physicalWidth;

  /// 物理设备的高
  static double _physicalHeight;

  /// 物理设备的像素密度
  static double _devicePixelRatio;

  /// 宽适配时候的比例
  static double _ratioW;

  /// 高适配时候的比例
  static double _ratioH;
  static double _statusBarHeight;
  static double _bottomBarHeight;
  static double _textScaleFactor;

  AutoLayout({
    this.designWidth = 750,
    this.designHeight = 1334,
    this.allowFontScaling = false,
    this.aspect = Aspect.aspectWidth,
    this.designDevicePixelRatio = 3.0,
  });

  void init({BuildContext context}) {
    _devicePixelRatio = window.devicePixelRatio;
    _physicalWidth = window.physicalSize.width;
    _physicalHeight = window.physicalSize.height;
    _ratioW = _physicalWidth / designWidth;
    _ratioH = _physicalHeight / designHeight;
    _statusBarHeight = window.padding.top;
    _bottomBarHeight = window.padding.bottom;
    _textScaleFactor = window.textScaleFactor;
//    print(
//        "_devicePixelRatio:$_devicePixelRatio _physicalWidth:$_physicalWidth _physicalHeight:$_physicalHeight");
//    print(
//        "_designWidth : $designWidth _desginHeight : $designHeight __designDevicePixelRatio : $designDevicePixelRatio");
//    print("_ratioW : $_ratioW _rationH : $_ratioH");
  }

  ///每个逻辑像素的字体像素数，字体的缩放比例
  static double get textScaleFactory => _textScaleFactor;

  ///设备的像素密度
  static double get devicePixelRatio => _devicePixelRatio;

  ///当前设备宽度 dp
  static double get physicalWidthDp => _physicalWidth;

  ///当前设备高度 dp
  static double get physicalHeightDp => _physicalHeight;

  ///当前设备宽度 px
  static double get physicalWidth => _physicalWidth * _devicePixelRatio;

  ///当前设备高度 px
  static double get physicalHeight => _physicalHeight * _devicePixelRatio;

  ///状态栏高度 dp 刘海屏会更高
  static double get statusBarHeight => _statusBarHeight;

  ///底部安全区距离 dp
  static double get bottomBarHeight => _bottomBarHeight;

  ///实际的dp与设计稿px的比例
  get scaleWidth => _physicalWidth / instance.designWidth;

  get scaleHeight => _physicalHeight / instance.designHeight;

  /// 将设计稿的px转换为dp
  double pxToDp(double px) {
    if (aspect == Aspect.aspectWidth) {
      return px * _ratioW / _devicePixelRatio;
    } else {
      return px * _ratioH / _devicePixelRatio;
    }
  }

  /// 将如果设计稿是dp的话，那么就直接传dp，但前提要设置对像素密度
  double dpToDp(double dp) {
    if (aspect == Aspect.aspectWidth) {
      return (dp * designDevicePixelRatio) * _ratioW / _devicePixelRatio;
    } else {
      return (dp * designDevicePixelRatio) * _ratioH / _devicePixelRatio;
    }
  }

  double setSp(double fontSize) => allowFontScaling
      ? fontSize * scaleWidth
      : (fontSize * scaleWidth) / _textScaleFactor;
}
