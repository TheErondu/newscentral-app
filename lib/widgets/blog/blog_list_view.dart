import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/app.dart';
import '../../models/blog_news.dart';
import '../../services/wordpress.dart';
import 'detailed_blog/blog_view.dart';

class BlogListView extends StatefulWidget {
  final List<BlogNews> blogs;
  final double screenWidth;
  final int cateId;
  BlogListView({this.blogs, this.screenWidth, this.cateId});

  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogListView> {
  RefreshController _refreshController;
  WordPress service = WordPress();
  int _page = 1;
  bool _isEnd = false;
  final double _padding = 2.0;
  List<BlogNews> _blogList = [];

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
    _refreshController =
        RefreshController(initialRefresh: widget.blogs == null);

    _blogList =
        widget.blogs == null || widget.blogs.isEmpty ? emptyList : widget.blogs;
  }

  Future<List<BlogNews>> _getBlogs() async {
    List<BlogNews> blogs = [];
    if (widget.cateId == null) {
      print(
          "sever url ${Provider.of<AppModel>(context, listen: false).appConfig['server']}");
      var _jsons = await BlogNews.getBlogs(
          url:
              Provider.of<AppModel>(context, listen: false).appConfig['server'],
          page: _page);
      print(Provider.of<AppModel>(context, listen: false).appConfig['server']);
      for (var item in _jsons) {
        blogs.add(BlogNews.fromJson(item));
      }
    } else {
      blogs = await service.fetchBlogsByCategory(
          categoryId: widget.cateId, page: _page);
    }
    return blogs;
  }

  _onRefresh() async {
    _page = 1;
    _isEnd = false;
    await _getBlogs();
    _refreshController.refreshCompleted();
  }

  _onLoading() async {
    if (!_isEnd) {
      _page = _page + 1;
      List<BlogNews> newBlogs = await _getBlogs();
      if (newBlogs.isEmpty) {
        _isEnd = true;
      }
      _blogList = []..addAll(_blogList)..addAll(newBlogs);
      _refreshController.refreshCompleted();
    }
    setState(() {});
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: const ClassicHeader(),
      enablePullDown: true,
      enablePullUp: !_isEnd,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(_padding),
        child: Column(
          children: List.generate(
            _blogList.length,
            (index) {
              return BlogCardView(
                blogs: _blogList,
                index: index,
                width: widget.screenWidth,
              );
            },
          ),
        ),
      ),
    );
  }
}
