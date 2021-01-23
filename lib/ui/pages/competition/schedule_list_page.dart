import 'package:flutter/material.dart';
import 'package:perbasitlg/ui/widgets/modules/schedule_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/models/schedule_model.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';

class ScheduleListPage extends StatefulWidget {
  final String competitionId;

  ScheduleListPage({Key key, this.competitionId}) : super(key: key);

  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  HomeCubit _homeCubit;

  @override
  void initState() {
    _homeCubit = BlocProvider.of<HomeCubit>(context);

    _homeCubit.schedule = [];
    _homeCubit.getCompetitionScheduleList(widget.competitionId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _homeCubit,
      listener: (context, state) {},
      child: BlocBuilder(
        cubit: _homeCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Jadwal Kompetisi',
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
            body: ReactiveRefreshIndicator(
              isRefreshing: _homeCubit.scheduleListLoading,
              onRefresh: () => _homeCubit.getCompetitionScheduleList(widget.competitionId),
              child: _mainBody()
            ),
          );
        }
      ),
    );
  }

  Widget _mainBody() {
    if (_homeCubit.homePageLoading) {
      return Container();
    } else {
      if (_homeCubit.schedule.isEmpty) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: Text('Tidak ada jadwal pertandingan'))],
        );
      } else {
        return Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _homeCubit.schedule.length,
            itemBuilder: (context, index) {
              ScheduleModel item = _homeCubit.schedule[index];

              return GestureDetector(
                onTap: () {},
                child: ScheduleItem(item: item),
              );
            }
          ),
        );
      }
    }
  }
}
