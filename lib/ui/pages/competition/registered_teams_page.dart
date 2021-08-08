import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/models/competition_model.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';
import 'package:perbasitlg/ui/widgets/modules/team_header.dart';

class RegisteredTeamsPage extends StatefulWidget {
  final String competitionId;

  RegisteredTeamsPage({this.competitionId});

  @override
  _RegisteredTeamsPageState createState() => _RegisteredTeamsPageState();
}

class _RegisteredTeamsPageState extends State<RegisteredTeamsPage> {
  HomeCubit _homeCubit;

  @override
  void initState() {
    _homeCubit = BlocProvider.of<HomeCubit>(context);

    _homeCubit.getCompetitionDetail(widget.competitionId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _homeCubit,
      listener: (context, state) {

      },
      child: BlocBuilder(
        cubit: _homeCubit,
        builder: (context, state) {
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
                'List Club Terdaftar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
            ),
            body: ReactiveRefreshIndicator(
              isRefreshing: _homeCubit.competitionDetailLoading,
              onRefresh:() => _homeCubit.getCompetitionDetail(widget.competitionId),
              child: !_homeCubit.competitionDetailLoading ? ListView.builder(
                shrinkWrap: true,
                itemCount: _homeCubit.competitionDetail?.teams?.length,
                itemBuilder: (context, index) {
                  Teams item = _homeCubit.competitionDetail?.teams[index];
                  return TeamHeader(
                    teamName: item?.team?.name,
                    logoUrl: item?.team?.logo,
                    teamType: item?.team?.type,
                  );
                },
              ) : Container(),
            ),
          );
        },
      ),
    );
  }
}
