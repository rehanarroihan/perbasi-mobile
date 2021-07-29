import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/ui/pages/team/player_detail_page.dart';
import 'package:perbasitlg/ui/widgets/modules/gender_options.dart';
import 'package:perbasitlg/ui/widgets/modules/player_thumbnail.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class PlayerListPage extends StatelessWidget {
  final Gender gender;
  final List<TeamPlayer> players;

  PlayerListPage({this.gender, this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
          'Pemain ${gender == Gender.L ? 'Pria' : 'Wanita'}',
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
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          )
        ),
        child: players.length > 0 ? GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          childAspectRatio: 9/14,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(14),
            vertical: ScreenUtil().setHeight(24)
          ),
          shrinkWrap: true,
          children: players.map<Widget>((TeamPlayer item) {
            String photoUrl = '';
            if (item.document.length > 0) {
              photoUrl = UrlConstantHelper.IMAGE_BASE_URL + item.document[0].file;
            }

            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => PlayerDetailPage(item: item)
              )),
              child: PlayerThumbnail(
                photoUrl: photoUrl,
                name: item.detail.name,
                position: 'Player',
                birthDay: item.detail.birthDate
              ),
            );
          }).toList(),
        ) :
        Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Tidak ada pemain')
          )
        ),
      ),
    );
  }
}
