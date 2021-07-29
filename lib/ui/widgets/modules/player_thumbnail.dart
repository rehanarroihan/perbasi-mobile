import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:intl/intl.dart';

class PlayerThumbnail extends StatelessWidget {
  final String photoUrl, name, birthDay, position;

  PlayerThumbnail({this.photoUrl, this.name, this.birthDay, this.position});

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
          Text('Posisi: ' + position),
          Text('Umur: ' + _calculateAge(DateTime.parse(birthDay)).toString()),
        ],
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
