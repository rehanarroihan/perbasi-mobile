import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:intl/intl.dart';

class FeedItem extends StatelessWidget {
  final String imageUrl, title, desc, date, status;

  FeedItem({this.imageUrl, this.title, this.desc, this.date, this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Stack(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(100),
                    color: Colors.red,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setHeight(100),
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _getBadgeColorByStatus(status)
                      ),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Space(width: 14),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    'Diterbitkan pada '+DateFormat('dd MMMM yyyy').format(DateTime.parse(this.date)),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Text(
                    desc,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Color _getBadgeColorByStatus(String status) {
    if (status == 'Pendaftaran') {
      return Colors.red.withOpacity(0.8);
    } else if (status == 'Berlangsung') {
      return Colors.green.withOpacity(0.8);
    } else if (status == 'Selesai') {
      return Colors.orange.withOpacity(0.8);
    } else {
      return Colors.purple.withOpacity(0.8);
    }
  }
}
