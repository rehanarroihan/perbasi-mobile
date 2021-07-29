import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/ui/pages/team/registrant_detail_page.dart';
import 'package:perbasitlg/ui/widgets/modules/player_thumbnail.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class TeamRegistrantPage extends StatefulWidget {
  final List<PlayerVerification> registrantList;

  TeamRegistrantPage({Key key, this.registrantList}) : super(key: key);

  @override
  _TeamRegistrantPageState createState() => _TeamRegistrantPageState();
}

class _TeamRegistrantPageState extends State<TeamRegistrantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
        title: Text(
          'List Pendaftar',
          style: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil().setSp(14)
          ),
        ),
      ),
      body: widget.registrantList.length > 0 ? GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        childAspectRatio: 9/14,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(14),
          vertical: ScreenUtil().setHeight(24)
        ),
        shrinkWrap: true,
        children: widget.registrantList.map<Widget>((PlayerVerification item) {
          String photoUrl = '';
          if (item.document.length > 0) {
            photoUrl = UrlConstantHelper.IMAGE_BASE_URL + item.document[0].file;
          }

          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => RegistrantDetailPage(item: item)
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
          child: Text('Belum ada pemain yang mendaftar')
        )
      ),
    );
  }
}