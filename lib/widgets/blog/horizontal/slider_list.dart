import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import '../../../common/tools.dart';
import '../../../models/app.dart';
import '../../../models/blog_news.dart';
import '../../../models/recent_blog.dart';
import '../../../services/wordpress.dart';
import '../../../widgets/blog/detailed_blog/blog_view.dart';
import '../../common/heart_button.dart';
import '../header/header_view.dart';

class HorizontalSliderList extends StatefulWidget {
  final config;

  HorizontalSliderList({this.config, Key key}) : super(key: key);

  @override
  _HorizontalSliderListState createState() => _HorizontalSliderListState();
}

class _HorizontalSliderListState extends State<HorizontalSliderList> {
  final WordPress _service = WordPress();
  Future<List<BlogNews>> _getBlogsLayout;
  final _memoizer = AsyncMemoizer<List<BlogNews>>();

  @override
  void initState() {
    // only create the future once
    Future.delayed(Duration.zero, () {
      setState(() {
        _getBlogsLayout = getBlogLayout(context);
      });
    });
    super.initState();
  }

  Future<List<BlogNews>> getBlogLayout(context) => _memoizer.runOnce(
        () => _service.fetchBlogLayout(
            config: widget.config,
            lang: Provider.of<AppModel>(context, listen: false).locale),
      );

  @override
  Widget build(BuildContext context) {
    final isRecent = widget.config["layout"] == "recentView" ? true : false;
    final recentBlog = Provider.of<RecentModel>(context, listen: false).blogs;
    final double imageBorder =
        Tools.formatDouble(widget.config["imageBorder"] ?? 3.0);

    final blogEmptyList = [
      BlogNews.empty(1),
      BlogNews.empty(2),
      BlogNews.empty(3)
    ];
    return FutureBuilder<List<BlogNews>>(
      future: _getBlogsLayout,
      builder: (BuildContext context, AsyncSnapshot<List<BlogNews>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: Container(
                child: Column(
                  children: <Widget>[
                    HeaderView(
                      headerText: widget.config["name"] != null
                          ? widget.config["name"]
                          : ' ',
                      showSeeAll: isRecent ? false : true,
                      callback: () => BlogNews.showList(
                          context: context,
                          config: widget.config,
                          blogs: snapshot.data),
                    ),
                    for (var i = 0; i < 3; i++)
                      BlogItem(
                        blogs: blogEmptyList,
                        index: i,
                        type: widget.config["type"],
                        imageBorder: imageBorder,
                        context: context,
                      )
                  ],
                ),
              ),
            );
          case ConnectionState.done:

          default:
            return Column(
              children: <Widget>[
                HeaderView(
                  headerText: widget.config["name"] != null
                      ? widget.config["name"]
                      : ' ',
                  showSeeAll: isRecent ? false : true,
                  callback: () => BlogNews.showList(
                      context: context,
                      config: widget.config,
                      blogs: isRecent ? recentBlog : snapshot.data),
                ),
                snapshot.hasError
                    ? const Text('No internet')
                    : Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        height: 540,
                        child: PageView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, position) {
                              if (position > 0 &&
                                  position < snapshot.data.length) {
                                position *= 3;
                              }
                              return Column(
                                children: <Widget>[
                                  for (var i = position;
                                      i < position + 3 &&
                                          i < snapshot.data.length;
                                      i++)
                                    BlogItem(
                                      blogs: snapshot.data,
                                      index: i,
                                      type: widget.config["type"],
                                      imageBorder: imageBorder,
                                    ),
                                ],
                              );
                            }),
                      )
              ],
            );
        }
      },
    );
  }
}

class BlogItem extends StatelessWidget {
  final List<BlogNews> blogs;
  final int index;
  final double width;
  final String type;
  final double imageBorder;
  final String locale;
  final context;
  BlogItem(
      {this.blogs,
      this.index,
      this.width,
      this.type,
      this.imageBorder,
      this.context,
      this.locale = 'en'});

  @override
  Widget build(BuildContext context) {
    double imageWidth = (width == null) ? 150 : width;
    double titleFontSize = imageWidth / 10;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  getDetailPageView(blogs.sublist(index), context),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: type == "imageOnTheRight"
              //display image on the right
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            blogs[index].title,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).accentColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: imageWidth / 35,
                          ),
                          Text(
                            blogs[index].date == ''
                                ? 'Loading ...'
                                : Tools.displayTimeAgoFromTimestamp(
                                    blogs[index].date),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          blogs[index].excerpt == "Loading..."
                              ? Text(
                                  blogs[index].excerpt,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          fontSize: 13.0,
                                          height: 1.4,
                                          color: Theme.of(context).accentColor),
                                )
                              : Text(
                                  parse(blogs[index].excerpt)
                                      .documentElement
                                      .text,
                                  maxLines: 3,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          fontSize: 13.0,
                                          height: 1.4,
                                          color: Theme.of(context).accentColor),
                                ),
//                              : HtmlWidget(
//                                  blogs[index].excerpt.substring(0, 100) + ' ...',
//                                  bodyPadding: EdgeInsets.only(top: 15),
//                                  hyperlinkColor: Theme.of(context).primaryColor.withOpacity(0.9),
//                                  textStyle: Theme.of(context).textTheme.body1.copyWith(
//                                      fontSize: 13.0,
//                                      height: 1.4,
//                                      color: Theme.of(context).accentColor),
//                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(imageBorder),
                          ),
                          child: Tools.image(
                            url: blogs[index].imageFeature,
                            width: imageWidth,
                            height: imageWidth,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: HeartButton(
                            blog: blogs[index],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              // else display image on the left
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(imageBorder),
                          ),
                          child: Tools.image(
                            url: blogs[index].imageFeature,
                            width: imageWidth,
                            height: imageWidth,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: HeartButton(
                            blog: blogs[index],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            blogs[index].title,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).accentColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: imageWidth / 35,
                          ),
                          Text(
                            blogs[index].date == ''
                                ? 'Loading ...'
                                : Tools.displayTimeAgoFromTimestamp(
                                    blogs[index].date),
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          blogs[index].excerpt == "Loading..."
                              ? Text(blogs[index].excerpt)
                              : Text(
                                  parse(blogs[index].excerpt)
                                      .documentElement
                                      .text,
                                  maxLines: 3,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          fontSize: 15.0,
                                          height: 1.4,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).accentColor),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
