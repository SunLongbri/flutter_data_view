import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

//图片预览组件
class PhotoPreviewWidget extends StatelessWidget {
  final List<String> goodsUrl;

  const PhotoPreviewWidget({Key key, this.goodsUrl}) : super(key: key); //图片网址

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (val){
        Navigator.pop(context);
      },
      child: Container(
          width: ScreenUtil().setWidth(152),
          height: AutoLayout.instance.pxToDp(136),
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(goodsUrl[index]),
                initialScale: PhotoViewComputedScale.contained * 0.8,
//                          heroAttributes: HeroAttributes(tag: galleryItems[index].id),
              );
            },
            itemCount: goodsUrl.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            ),
//                      backgroundDecoration: widget.backgroundDecoration,
//                      pageController: widget.pageController,
//                      onPageChanged: onPageChanged,
          )),
    );
  }
}
