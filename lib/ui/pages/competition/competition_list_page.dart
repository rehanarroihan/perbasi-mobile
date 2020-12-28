import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/models/competition_model.dart';
import 'package:perbasitlg/ui/pages/competition/competition_detail_page.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';
import 'package:perbasitlg/ui/widgets/modules/feed_item.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class CompetitionListPage extends StatefulWidget {
  CompetitionListPage({Key key}) : super(key: key);

  @override
  _CompetitionListPageState createState() => _CompetitionListPageState();
}

class _CompetitionListPageState extends State<CompetitionListPage> {
  HomeCubit _homeCubit;

  @override
  void initState() {
    _homeCubit = BlocProvider.of<HomeCubit>(context);

    if (_homeCubit.newsList.isEmpty || _homeCubit.competitions.isEmpty) {
      _homeCubit.getHomePageData();
    }

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
              iconTheme: IconThemeData(
                color: Colors.black
              ),
              title: Text(
                'List Kompetisi',
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
              isRefreshing: _homeCubit.homePageLoading,
              onRefresh: () => _homeCubit.getHomePageData(),
              child: _homeCubit.homePageLoading ? Container() : Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _homeCubit.competitions.length,
                  itemBuilder: (context, index) {
                    CompetitionModel item = _homeCubit.competitions[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CompetitionDetailPage(
                            competitionDetail: item,
                          )
                        ));
                      },
                      child: FeedItem(
                        imageUrl: item.foto.replaceAll('https:///', 'https://'),
                        title: item.name,
                        desc: GlobalMethodHelper.parseHtmlString(item.description)
                      ),
                    );
                  }
                ),
              )
            ),
          );
        }
      ),
    );
  }
}