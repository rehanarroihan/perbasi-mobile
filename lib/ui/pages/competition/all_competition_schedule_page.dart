import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/models/schedule_model.dart';
import 'package:perbasitlg/ui/pages/competition/competition_detail_page.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/schedule_item.dart';

class AllCompetitionSchedulePage extends StatefulWidget {
  AllCompetitionSchedulePage({Key key}) : super(key: key);

  @override
  _AllCompetitionSchedulePageState createState() => _AllCompetitionSchedulePageState();
}

class _AllCompetitionSchedulePageState extends State<AllCompetitionSchedulePage> {
  HomeCubit _homeCubit;

  @override
  void initState() {
    _homeCubit = BlocProvider.of<HomeCubit>(context);

    _homeCubit.getAllCompetitionScheduleList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _homeCubit,
      listener: (context, state) {
        if (state is GetCompetitionDetailForScheduleListInit) {
          LoadingDialog(
            title: 'Silahkan Tunggu',
            description: 'Memuat detail'
          ).show(context);
        } else if (state is GetCompetitionDetailForScheduleListResult) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => CompetitionDetailPage(
              competitionDetail: state.result,
            )
          ));
        }
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
              title: Text(
                'List Jadwal Kompetisi',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
            ),
            body: ReactiveRefreshIndicator(
              isRefreshing: _homeCubit.allScheduleListLoading,
              onRefresh: () => _homeCubit.getHomePageData(),
              child: _homeCubit.allScheduleListLoading ? Container() : Container(
                child: _mainBody()
              )
            ),
          );
        },
      ),
    );
  }

  Widget _mainBody() {
    if (_homeCubit.allScheduleListLoading) {
      return Container();
    } else {
      if (_homeCubit.allSchedule.isEmpty) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: Text('Tidak ada jadwal pertandingan'))],
        );
      } else {
        return Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _homeCubit.allSchedule.length,
            itemBuilder: (context, index) {
              ScheduleModel item = _homeCubit.allSchedule[index];

              return GestureDetector(
                onTap: () {
                  _homeCubit.getCompetitionDetailForScheduleListPage(item.competitionId);
                },
                child: ScheduleItem(item: item),
              );
            }
          ),
        );
      }
    }
  }
}