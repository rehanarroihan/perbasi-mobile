import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:photo_view/photo_view_gallery.dart';

class QrCodePage extends StatefulWidget {
  final String qrCodeUrl;

  QrCodePage({
    @required this.qrCodeUrl,
  });

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
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
          'QR Code',
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
        onPageChanged: (int index) {
          setState(() {
            _currentImagePage = index;
          });
        },
        pageOptions: [
          PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.qrCodeUrl),
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
