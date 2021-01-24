import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/models/competition_model.dart';
import 'package:perbasitlg/models/news_model.dart';
import 'package:perbasitlg/ui/pages/news/news_detail_page.dart';
import 'package:perbasitlg/ui/widgets/base/reactive_refresh_indicator.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/feed_item.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class NewsListPage extends StatefulWidget {
  NewsListPage({Key key}) : super(key: key);

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
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
                'List Berita',
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
                  itemCount: _homeCubit.newsList.length,
                  itemBuilder: (context, index) {
                    NewsModel item = _homeCubit.newsList[index];

                    String imageUrl = '';
                    if (item.foto.length > 0) {
                      imageUrl = item.foto[0];
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => NewsDetailPage(newsDetail: item)
                        ));
                      },
                      child: FeedItem(
                        imageUrl: imageUrl,
                        title: item.title,
                        date: item.createdAt,
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