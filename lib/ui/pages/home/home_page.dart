import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/models/competition_model.dart';
import 'package:perbasitlg/models/news_model.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                'Perbasi',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {}
                )
              ],
            ),
            body: ReactiveRefreshIndicator(
              isRefreshing: _homeCubit.homePageLoading,
              onRefresh: () => _homeCubit.getHomePageData(),
              child: _homeCubit.homePageLoading ? Container() : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _mainThumbnail(),
                    Space(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16)
                      ),
                      child: _horizontalTitleActionText(
                        title: 'Kompetisi',
                        actionText: 'Lihat Semua',
                        actionOnClick: () {}
                      ),
                    ),
                    Space(height: 16),
                    _competitionList(),

                    Space(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(14)
                      ),
                      child: _horizontalTitleActionText(
                        title: 'Berita',
                        actionText: 'Lihat Semua',
                        actionOnClick: () {}
                      ),
                    ),
                    Space(height: 16),
                    _newsList(),

                    Space(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mainThumbnail() {
    return Container(
      height: ScreenUtil().setHeight(172),
      width: double.infinity,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width * 0.62,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: _homeCubit.highlightCompetition.foto.replaceAll('https:///', 'https://'),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 1],
                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)]
                  )
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _homeCubit.highlightCompetition.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _competitionList() {
    return Container(
      height: ScreenUtil().setHeight(204),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _homeCubit.competitions.length,
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          CompetitionModel item = _homeCubit.competitions[index];
          return _dataThumbnail(
            imageUrl: item.foto.replaceAll('https:///', 'https://'),
            title: item.name,
            desc: GlobalMethodHelper.parseHtmlString(item.description)
          );
        },
      ),
    );
  }

  Widget _newsList() {
    return Container(
      height: ScreenUtil().setHeight(204),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _homeCubit.newsList.length,
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          NewsModel item = _homeCubit.newsList[index];
          String imageUrl = '';
          if (item.foto.length > 0) {
            imageUrl = 'https://perbasitulungagung.com/adm/' + item.foto[0];
          }

          return _dataThumbnail(
            imageUrl: imageUrl,
            title: item.title,
            desc: GlobalMethodHelper.parseHtmlString(item.description)
          );
        },
      ),
    );
  }

  Widget _horizontalTitleActionText({String title, String actionText, Function actionOnClick}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black
          ),
        ),
        GestureDetector(
          onTap: actionOnClick,
          child: Text(
            actionText,
            style: TextStyle(
              color: AppColor.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
        )
      ],
    );
  }

  Widget _dataThumbnail({String imageUrl, String title, String desc}) {
    return Container(
      width: ScreenUtil().setWidth(230),
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(126),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Space(height: 8),
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15
              ),
            ),
          ),
          Flexible(
            child: Text(
              desc,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
