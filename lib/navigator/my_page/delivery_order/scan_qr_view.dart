import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/qrcode.dart';

import '../../../provider/data_provider.dart';
import '../../../utils/auto_layout.dart';
import '../../../widgets/appbar_widget.dart';

class ScanQrView extends StatefulWidget {
  @override
  _ScanQrViewState createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  QRCaptureController _captureController = QRCaptureController();
  String _captureText = ''; //扫码接收数据
  bool _camState = false; //是否可以扫码
  DataProvider _dataProvider;

  _qrCallback(String code) {
    setState(() {
      _camState = false;
      _captureText = code;
      Navigator.pop(context, _captureText);
    });
  }

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  void initState() {
    super.initState();
    Platform.isIOS
        ? _scanCode()
        : _captureController.onCapture((data) {
            print('onCapture----$data');
            setState(() {
              _captureText = data;
              _captureController.pause();
              _dataProvider.sacnCode = _captureText;
              Navigator.pop(context, _captureText);
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
        appBar: AppBarWidget(),
        body: Platform.isIOS
            ? Container(
                child: _camState
                    ? Center(
                        child: SizedBox(
                          height: AutoLayout().dpToDp(1334),
                          width: ScreenUtil().setWidth(750),
                          child: QRBarScannerCamera(
                            onError: (context, error) => Text(
                              error.toString(),
                              style: TextStyle(color: Colors.red),
                            ),
                            qrCodeCallback: (code) {
                              _qrCallback(code);
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Text(_captureText),
                      ),
              )
            : Container(
                height: AutoLayout().dpToDp(1334),
                width: ScreenUtil().setWidth(750),
                child: QRCaptureView(
                  controller: _captureController,
                )));
  }
}
