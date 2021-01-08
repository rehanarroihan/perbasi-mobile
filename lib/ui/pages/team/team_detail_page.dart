import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/models/club_model.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';
import 'package:perbasitlg/ui/widgets/modules/app_alert_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/team_detail_section.dart';
import 'package:perbasitlg/utils/app_color.dart';

class TeamDetailPage extends StatefulWidget {
  final ClubModel clubDetail;

  TeamDetailPage({Key key, this.clubDetail}) : super(key: key);

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  TeamCubit _teamCubit = TeamCubit();

  @override
  void initState() {
    _teamCubit = BlocProvider.of<TeamCubit>(context);

    _teamCubit.getTeamDetail(widget.clubDetail.id.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _teamCubit,
      listener: (context, state) {
        if (state is RegisterToTeamInit) {
          Navigator.pop(context);
          LoadingDialog(
            title: 'Loading',
            description: 'Silahkan tunggu...'
          ).show(context);
        } else if (state is RegisterToTeamSuccessfulState) {
          Navigator.pop(context);
          AppAlertDialog(
            title: 'Daftar Team',
            description: 'Berhasil mendaftar ke team ${widget.clubDetail.name}, silahkan tunggu verifikasi',
            positiveButtonText: 'Ok',
            positiveButtonOnTap: () => Navigator.pop(context),
          ).show(context);
        } else if (state is RegisterToTeamFailedState) {
          Navigator.pop(context);
          AppAlertDialog(
            title: 'Daftar Team',
            description: state.message,
            positiveButtonText: 'Ok',
            positiveButtonOnTap: () => Navigator.pop(context),
          ).show(context);
        }
      },
      child: BlocBuilder(
        cubit: _teamCubit,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.pageBackgroundColor,
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
                'Detail Team',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
            ),
            body: ReactiveRefreshIndicator(
              onRefresh: () => _teamCubit.getTeamDetail(widget.clubDetail.id.toString()),
              isRefreshing: _teamCubit.teamDetailPageLoading,
              child: _teamCubit.teamDetailPageLoading
                  ? Column(mainAxisSize: MainAxisSize.max)
                  : Column(
                    children: [
                      TeamDetailSection(_teamCubit.clubDetail),
                      !_teamCubit.userHaveTeam ?
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 24),
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(46)
                        ),
                        child: Button(
                          style: AppButtonStyle.secondary,
                          text: 'Daftar Team',
                          fontSize: 14,
                          padding: 12,
                          onPressed: () {
                            AppAlertDialog(
                              title: 'Daftar Team',
                              description: 'Apakah anda yakin ingin daftar ke team ${widget.clubDetail.name} ?',
                              negativeButtonText: 'Tidak',
                              negativeButtonOnTap: () => Navigator.pop(context),
                              positiveButtonText: 'Ya',
                              positiveButtonOnTap: () => _teamCubit.registerToTeam(
                                _teamCubit.clubDetail.detailTeam.id.toString()
                              ),
                            ).show(context);
                          },
                        ),
                      ) :
                      Container()
                    ],
                  ),
            ),
          );
        },
      ),
    );
  }
}