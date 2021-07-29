import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageDetailPage extends StatefulWidget {
  final String title, imageDetail;

  ImageDetailPage({
    @required this.title,
    @required this.imageDetail,
  });

  @override
  _ImageDetailPageState createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  PageController _controller;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil().setSp(14)
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: PhotoViewGallery(
        pageController: _controller,
        onPageChanged: (int index) {},
        pageOptions: [
          PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imageDetail),
          )
        ],
        loadingBuilder: (context, progress) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(),
          ),
        ),
        backgroundDecoration: BoxDecoration(
          color: AppColor.pageBackgroundColor
        ),
      ),
    );
  }
}
