import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/ui/pages/team/team_detail_page.dart';
import 'package:perbasitlg/ui/pages/team/team_registrant_page.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/team_detail_section.dart';
import 'package:perbasitlg/ui/widgets/modules/team_header.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class TeamPage extends StatefulWidget {
  TeamPage({Key key}) : super(key: key);

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  TeamCubit _teamCubit = TeamCubit();
  AuthCubit _authCubit = AuthCubit();

  @override
  void initState() {
    _teamCubit = BlocProvider.of<TeamCubit>(context);
    _authCubit = BlocProvider.of<AuthCubit>(context);

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
                _teamCubit.teamPageLoading
                    ? 'Loading...'
                    : _teamCubit.userHaveTeam
                      ? 'Team Saya'
                      : 'List Team',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
              actions: _teamCubit.userCanVerif ? [
                Center(
                  child: FlatButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TeamRegistrantPage(
                        registrantList: _teamCubit.myClubDetail.playerVerification
                      )
                    )),
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
            _authCubit.loggedInUserData.role.name == ConstantHelper.ROLE_PEMAIN ?
            RaisedButton(
              onPressed: () {},
              child: Text('Keluar Team'),
            ) :
            Container(),
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