import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/models/competition_model.dart';
import 'package:perbasitlg/ui/pages/competition/schedule_list_page.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class CompetitionDetailPage extends StatelessWidget {
  final CompetitionModel competitionDetail;

  CompetitionDetailPage({this.competitionDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
          'Detail Kompetisi',
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
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(168),
                  color: AppColor.primaryColor,
                  child: CachedNetworkImage(
                    imageUrl: competitionDetail.foto,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(168),
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _getBadgeColorByStatus(competitionDetail.status)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      competitionDetail.status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Space(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
              child: Text(
                competitionDetail.name,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
              ),
            ),
            Space(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
              child: ExpandableText(
                GlobalMethodHelper.parseHtmlString(competitionDetail.description),
              ),
            ),
            Space(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
              width: double.infinity,
              child: Button(
                style: AppButtonStyle.secondary,
                text: 'Syarat Pendaftaran',
                onPressed: () async {
                  String url = competitionDetail.fileRequirement;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            Space(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
              width: double.infinity,
              child: Button(
                style: AppButtonStyle.secondary,
                text: 'Jadwal Kompetisi',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ScheduleListPage(
                      competitionId: competitionDetail.id.toString()
                    )
                  ));
                },
              ),
            ),
            Space(height: 12),
          ],
        ),
      ),
    );
  }

  Color _getBadgeColorByStatus(String status) {
    if (status == 'Pendaftaran') {
      return Colors.red.withOpacity(0.7);
    } else if (status == 'Berlangsung') {
      return Colors.green.withOpacity(0.7);
    } else if (status == 'Selesai') {
      return Colors.orange.withOpacity(0.7);
    } else {
      return Colors.purple.withOpacity(0.7);
    }
  }
}

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ConstrainedBox(
          constraints: widget.isExpanded
              ? BoxConstraints()
              : BoxConstraints(maxHeight: 90.0),
          child: Text(
            widget.text,
            textAlign: TextAlign.justify,
            softWrap: true,
            overflow: TextOverflow.fade,
          )),
      widget.isExpanded
          ? Container()
          : FlatButton(
          child: const Text('Lihat Selengkapnya...', style: TextStyle(color: Colors.deepOrangeAccent)),
          onPressed: () => setState(() => widget.isExpanded = true))
    ]);
  }
}