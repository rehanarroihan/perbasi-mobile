import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/models/news_model.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class NewsDetailPage extends StatelessWidget {
  NewsModel newsDetail;

  NewsDetailPage({this.newsDetail});

  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
    if (newsDetail.foto.length > 0) {
      imageUrl = 'https://perbasitulungagung.com/adm/' + newsDetail.foto[0];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
          'Detail Berita',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(168),
              color: AppColor.primaryColor,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Space(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
              child: Text(
                newsDetail.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
              ),
            ),
            Space(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
              child: Text(
                GlobalMethodHelper.parseHtmlString(newsDetail.description),
                style: TextStyle(
                  fontSize: 15
                ),
              ),
            ),
            Space(height: 12),
          ],
        ),
      ),
    );
  }
}
