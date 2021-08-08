import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/models/request/exit_club_request.dart';
import 'package:perbasitlg/ui/pages/team/team_detail_page.dart';
import 'package:perbasitlg/ui/pages/team/team_registrant_page.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/app_alert_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/team_detail_section.dart';
import 'package:perbasitlg/ui/widgets/modules/team_header.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/show_flutter_toast.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';

class TeamPage extends StatefulWidget {
  TeamPage({Key key}) : super(key: key);

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  TeamCubit _teamCubit = TeamCubit();
  AuthCubit _authCubit = AuthCubit();

  ClubDetail _selectedMyClub;

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
      listener: (context, state) {
        if (state is ExitTeamInit) {
          Navigator.pop(context);
          LoadingDialog(
            title: 'Loading',
            description: 'Silahkan tunggu...'
          ).show(context);
        } else if (state is ExitTeamSuccessfulState) {
          Navigator.pop(context);
          showFlutterToast('Berhasil keluar dari club');
          _teamCubit.getMyTeamPage();
        } else if (state is ExitTeamFailedState) {
          Navigator.pop(context);
          AppAlertDialog(
            title: 'Keluar Club',
            description: 'Gagal keluar dari team, mohon coba lagi',
            positiveButtonText: 'Oke',
            positiveButtonOnTap: () => Navigator.pop(context),
          ).show(context);
        }
      },
      child: BlocBuilder(
        cubit: _teamCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black
              ),
              leading: _selectedMyClub != null ? IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedMyClub = null;
                  });
                },
              ) : null,
              title: Text(
                _teamCubit.teamPageLoading
                    ? 'Loading...'
                    : 'List Club',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
              actions: _selectedMyClub != null ? _selectedMyClub.canVerification ? [
                Center(
                  child: FlatButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TeamRegistrantPage(
                        registrantList: _selectedMyClub.playerVerification
                      )
                    )),
                    child: Text(
                      'Lihat Pendaftar (${_selectedMyClub.playerVerification.length})',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent
                      ),
                    ),
                  ),
                )
              ] : [] : [],
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
    // if (_teamCubit.userHaveTeam) {
    //   if (_selectedMyClub == null) {
    //     return ListView.builder(
    //       shrinkWrap: true,
    //       itemCount: _teamCubit.myClubList.length,
    //       itemBuilder: (context, index) {
    //         ClubDetail item = _teamCubit.myClubList[index];
    //         return GestureDetector(
    //           onTap: () {
    //             setState(() {
    //               _selectedMyClub = item;
    //             });
    //           },
    //           child: TeamHeader(
    //             teamName: item.detailTeam.name,
    //             logoUrl: UrlConstantHelper.IMAGE_BASE_URL + item.detailTeam.logo,
    //             teamType: item.detailTeam.type,
    //           ),
    //         );
    //       },
    //     );
    //   } else {
    //     return SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           TeamDetailSection(_selectedMyClub),
    //           Space(height: 12),
    //           _authCubit.loggedInUserData.role.name == ConstantHelper.ROLE_PEMAIN ?
    //           Container(
    //             width: double.infinity,
    //             margin: EdgeInsets.only(top: 24),
    //             padding: EdgeInsets.symmetric(
    //               horizontal: ScreenUtil().setWidth(46)
    //             ),
    //             child: Button(
    //               style: AppButtonStyle.primary,
    //               text: 'Keluar Club',
    //               fontSize: 14,
    //               padding: 12,
    //               onPressed: () {
    //                 AppAlertDialog(
    //                   title: 'Keluar Club',
    //                   description: 'Apakah anda yakin ingin keluar dari team ?',
    //                   negativeButtonText: 'Tidak',
    //                   negativeButtonOnTap: () => Navigator.pop(context),
    //                   positiveButtonText: 'Ya',
    //                   positiveButtonOnTap: () {
    //                     TeamPlayer tp = _selectedMyClub.teamPlayer.where((ply) {
    //                       return ply.detail.userId == _authCubit.loggedInUserData.id.toString();
    //                     }).toList().first;
    //
    //                     _teamCubit.exitFromTeam(ExitClubRequest(
    //                       playerId: tp.playerId,
    //                       teamId: _selectedMyClub.detailTeam.id.toString()
    //                     ));
    //                   },
    //                 ).show(context);
    //               },
    //             ),
    //           ) :
    //           Container(),
    //           Space(height: 32),
    //         ],
    //       ),
    //     );
    //   }
    // } else {
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
              teamType: item.type,
            ),
          );
        },
      );
    // }
  }
}