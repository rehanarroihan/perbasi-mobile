import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';

class PlayerThumbnail extends StatelessWidget {
  final String photoUrl, name, yearsOld, post;

  PlayerThumbnail({this.photoUrl, this.name, this.yearsOld, this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.red,
              height: ScreenUtil().setHeight(160),
              width: ScreenUtil().setWidth(160),
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Space(height: 12),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Text('Posisi: ' + post),
          Text('Umur: ' + yearsOld),
        ],
      ),
    );
  }
}
