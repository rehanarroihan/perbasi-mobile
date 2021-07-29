import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/app_color.dart';

class TeamHeader extends StatelessWidget {
  final String teamName, logoUrl;

  TeamHeader({this.teamName, this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        )
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: logoUrl,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover
                ),
              ),
            ),
          ),
          Space(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(teamName),
              Text('Club', style: TextStyle(color: AppColor.primaryColor))
            ],
          )
        ],
      ),
    );
  }
}
