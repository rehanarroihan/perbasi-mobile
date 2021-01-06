import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/ui/pages/team/team_detail_page.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/team_detail_section.dart';
import 'package:perbasitlg/ui/widgets/modules/team_header.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class TeamPage extends StatefulWidget {
  TeamPage({Key key}) : super(key: key);

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  TeamCubit _teamCubit = TeamCubit();

  @override
  void initState() {
    _teamCubit = BlocProvider.of<TeamCubit>(context);

    _teamCubit.getMyTeamPage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _teamCubit,
      listener: (context, state) {},
      child: BlocBuilder(
        cubit: _teamCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black
              ),
              title: Text(
                'Team Saya',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
              actions: _teamCubit.userCanVerif ? [
                Center(
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Lihat Pendaftar',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent
                      ),
                    ),
                  ),
                )
              ] : [],
            ),
            body: ReactiveRefreshIndicator(
              isRefreshing: _teamCubit.teamPageLoading,
              onRefresh: () => _teamCubit.getMyTeamPage(),
              child: _teamCubit.teamPageLoading ? Container() : _buildPage(),
            ),
          );
        },
      )
    );
  }

  Widget _buildPage() {
    if (_teamCubit.userHaveTeam) {
      return SingleChildScrollView(
        child: Column(
          children: [
            TeamDetailSection(_teamCubit.myClubDetail),
            Space(height: 12),
            RaisedButton(
              onPressed: () {},
              child: Text('Keluar Team'),
            ),
            Space(height: 12),
          ],
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _teamCubit.teamList.length,
        itemBuilder: (context, index) {
          ClubModel item = _teamCubit.teamList[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => TeamDetailPage(clubDetail: item)
            )),
            child: TeamHeader(
              teamName: item.name,
              logoUrl: UrlConstantHelper.IMAGE_BASE_URL + item.logo,
            ),
          );
        },
      );
    }
  }
}