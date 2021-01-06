import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/models/club_model.dart';
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
    return BlocBuilder(
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
          body: _teamCubit.teamDetailPageLoading ? Container() : TeamDetailSection(_teamCubit.clubDetail),
        );
      },
    );
  }
}