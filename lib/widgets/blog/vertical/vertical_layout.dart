import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import '../../../common/tools.dart';
import '../../../models/blog_news.dart';
import '../../../services/wordpress.dart';
import '../../../widgets/blog/header/header_view.dart';
import '../../../widgets/blog_news/blog_card_view.dart';
import 'vertical_simple_list.dart';

class VerticalViewLayout extends StatefulWidget {
  final config;

  VerticalViewLayout({this.config});

  @override
  _VerticalViewLayoutState createState() => _VerticalViewLayoutState();
}

class _VerticalViewLayoutState extends State<VerticalViewLayout> {
  final WordPress _service = WordPress();
  List<BlogNews> _blogs = [];
  int _page = 0;
  bool canLoad = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  _loadProduct() async {
    var config = widget.config;
    _page = _page + 1;
    config['page'] = _page;
    if (!canLoad) return;
    var newBlogs = await _service.fetchBlogLayout(config: config);
    if (newBlogs.isEmpty) {
      setState(() {
        canLoad = false;
      });
    }
    setState(() {
      _blogs = [..._blogs, ...newBlogs];
    });
  }

  @override
  Widget build(BuildContext context) {
    var widthContent = 0.0;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = Tools.isTablet(MediaQuery.of(context));
    final widthScreen = screenSize.width;

    if (widget.config['layout'] == "card") {
      widthContent = widthScreen; //one column
    } else if (widget.config['layout'] == "columns") {
      widthContent =
          isTablet ? widthScreen / 4 : (widthScreen / 3) - 15; //three columns
    } else {
      //layout is list
      widthContent =
          isTablet ? widthScreen / 3 : (widthScreen / 2) - 20; //two columns
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Column(
        children: <Widget>[
          if (widget.config["name"] != null)
            HeaderView(
              headerText: widget.config["name"] ?? '',
              showSeeAll: true,
              callback: () => BlogNews.showList(
                context: context,
                config: widget.config,
              ),
            ),
          SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                for (var i = 0; i < _blogs.length; i++)
                  widget.config['layout'] == 'list'
                      ? SimpleListView(
                          item: _blogs[i], type: SimpleListType.BackgroundColor)
                      : BlogCard(
                          item: _blogs[i],
                          width: widthContent,
                        ),
              ],
            ),
          ),
          VisibilityDetector(
            key: const Key("loading_vertical"),
            child: !canLoad
                ? Container()
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Center(
                      child: Text('Loading'),
                    ),
                  ),
            onVisibilityChanged: (VisibilityInfo info) => _loadProduct(),
          )
        ],
      ),
    );
  }
}
