import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/models/schedule_model.dart';
import 'package:intl/intl.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  final ScheduleModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.black26,
          width: 1,
        ),
      )),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Text(
                    item.teamHome.name,
                    textAlign: TextAlign.end,
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    'vs',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
              Expanded(
                  flex: 4,
                  child: Text(
                    item.teamAway.name,
                    textAlign: TextAlign.start,
                  )),
            ],
          ),
          item.results != null
              ? Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text(
                            item.results.home.toString(),
                            textAlign: TextAlign.end,
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 4, child: Text(item.results.away.toString())),
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                  child: Text(
                    DateFormat('dd MMMM yyyy, HH:mm').format(
                        DateTime.parse(item.playDate + ' ' + item.playTime)),
                    style: TextStyle(color: Color(0xFF007813)),
                  ),
                )
        ],
      ),
    );
  }
}
