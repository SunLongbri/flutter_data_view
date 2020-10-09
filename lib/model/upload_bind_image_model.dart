import 'dart:io';

//上传衣物时，附带的图片数据模型
class UploadBindImageModel {
  String orderId;
  String goodsCode;
  String barcodeId;
  List<File> goodsFiles;

  UploadBindImageModel(
      {this.orderId, this.goodsCode, this.barcodeId, this.goodsFiles});
}
