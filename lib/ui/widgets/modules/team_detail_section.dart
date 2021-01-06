import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/user_model.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/team_header.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class TeamDetailSection extends StatelessWidget {
  final ClubDetail clubDetail;

  TeamDetailSection(this.clubDetail);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: const Offset(0, -3),
                  blurRadius: 24,
                ),
              ],
              color: Colors.white
            ),
            child: Column(
              children: [
                TeamHeader(
                  logoUrl: UrlConstantHelper.IMAGE_BASE_URL + clubDetail.detailTeam.logo,
                  teamName: clubDetail.detailTeam.name,
                ),
                Row(
                  children: [
                    _stats(title: 'Played', value: 0.toString()),
                    _stats(title: 'Win', value: 0.toString()),
                    _stats(title: 'Loses', value: 0.toString()),
                  ],
                ),
              ],
            ),
          ),
          Space(height: 14),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1,
                ),
              )
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(16),
              vertical: ScreenUtil().setHeight(12)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Pelatih'),
                Text(
                  clubDetail.teamCoach.length > 0 ? clubDetail.teamCoach[0].detail.name : '-',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(14)
                  ),
                )
              ],
            ),
          ),
          _expndbl(
            context: context,
            textHeader: 'Sejarah Team',
            body: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ),
                )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Space(height: 12),
                    Text(
                      clubDetail.detailTeam.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Space(height: 8),
                    Text(GlobalMethodHelper.parseHtmlString(clubDetail.detailTeam.sejarah))
                  ],
                ),
              ),
            )
          ),
          _expndbl(
            context: context,
            textHeader: 'Pemain',
            body: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ),
                )
              ),
              child: clubDetail.teamPlayer.length > 0 ? GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                childAspectRatio: 9/14,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(14),
                  vertical: ScreenUtil().setHeight(24)
                ),
                shrinkWrap: true,
                children: clubDetail.teamPlayer.map<Widget>((UserModel item) {
                  return _playerThumbnail(
                    photoUrl: item.foto,
                    name: item.name,
                    post: 'Player',
                    yearsOld: item.birthDate
                  );
                }).toList(),
              ) :
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Tidak ada pemain')
                )
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _stats({String title, String value}) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(12)),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          )
        ),
        child: Column(
          children: [
            Text(title),
            Space(height: 4),
            Text(value),
          ],
        ),
      ),
    );
  }

  Widget _expndbl({BuildContext context, String textHeader, Widget body}) {
    return ExpandableNotifier(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          )
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(1),
          vertical: ScreenUtil().setHeight(8)
        ),
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                  child: Text(textHeader)
                ),
                collapsed: body,
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _playerThumbnail({String photoUrl, String name, String post, String yearsOld}) {
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
                imageUrl: 'https://scontent-cgk1-1.cdninstagram.com/v/t51.2885-15/e35/90474346_194335755205095_8700616338898959281_n.jpg?_nc_ht=scontent-cgk1-1.cdninstagram.com&_nc_cat=103&_nc_ohc=SH9fQFqQAiAAX-OChgH&tp=1&oh=5a8306558cbcaf46eeeba5c4f7bf8dc7&oe=60207AF2',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Space(height: 12),
          Flexible(
            child: Text(
              'Galbie Elinour',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Text('sf'),
          Text('sf'),
        ],
      ),
    );
  }
}
