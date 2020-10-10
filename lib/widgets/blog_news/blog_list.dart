import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/blog_news.dart';
import 'blog_card_view.dart';

class BlogList extends StatefulWidget {
  final List<BlogNews> blogs;
  final bool isFetching;
  final bool isEnd;
  final String errMsg;
  final width;
  final padding;
  final String layout;
  final Function onRefresh;
  final Function onLoadMore;

  BlogList({
    this.isFetching = false,
    this.isEnd = true,
    this.errMsg,
    this.blogs,
    this.width,
    this.padding = 8.0,
    this.onRefresh,
    this.onLoadMore,
    this.layout = "list",
  });

  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  RefreshController _refreshController;
  int _page = 1;

  List<BlogNews> emptyList = [
    BlogNews.empty(1),
    BlogNews.empty(2),
    BlogNews.empty(3),
    BlogNews.empty(4),
    BlogNews.empty(5),
    BlogNews.empty(6)
  ];

  @override
  initState() {
    super.initState();

    /// if there are existing product from previous navigate we don't need to enable the refresh
    _refreshController = RefreshController(initialRefresh: false);
  }

  _onRefresh() async {
    if (!widget.isFetching) {
      _page = 1;
      widget.onRefresh();
    }
  }

  _onLoading() async {
    if (!widget.isFetching && !widget.isEnd) {
      _page = _page + 1;
      widget.onLoadMore(_page);
    }
  }

  @override
  void didUpdateWidget(BlogList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isFetching == false && oldWidget.isFetching == true) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
//        final screenSize = MediaQuery.of(context).size;
//        final isTablet = Tools.isTablet(MediaQuery.of(context));
        final widthScreen =
            widget.width != null ? widget.width : constraints.maxWidth;
        var widthContent = 0.0;
        if (widget.layout == "card") {
          widthContent = widthScreen; //one column
        } else if (widget.layout == "columns") {
          widthContent = constraints.maxWidth / 3 - 18;
        } else {
          //layout is list
          widthContent = constraints.maxWidth / 2 - 20;
        }

        final blogsList =
            (widget.blogs == null || widget.blogs.isEmpty) && widget.isFetching
                ? emptyList
                : widget.blogs;

        if (blogsList == null || blogsList.isEmpty) {
          return const Center(
              child:
                  Text("No Articles", style: TextStyle(color: Colors.black)));
        }
        return SmartRefresher(
          header: MaterialClassicHeader(
              backgroundColor: Theme.of(context).primaryColor),
          enablePullDown: true,
          enablePullUp: !widget.isEnd,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var i = 0; i < blogsList.length; i++)
                    BlogCardCanSwipe(
                      blogs: blogsList,
                      index: i,
                      width: widthContent,
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
