import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../../../common/tools.dart';
import '../../../models/blog_news.dart';
import '../../../services/wordpress.dart';
import '../../common/heart_button.dart';
import 'blog_view.dart';

// ignore: must_be_immutable
class RelatedBlogList extends StatefulWidget {
  final categoryId;
  String type;
  RelatedBlogList({this.categoryId, this.type});
  @override
  _RelatedBlogListState createState() => _RelatedBlogListState();
}

class _RelatedBlogListState extends State<RelatedBlogList> {
  final WordPress _service = WordPress();
  Future<List<BlogNews>> _getBlogsLayout;
  final _memoizer = AsyncMemoizer<List<BlogNews>>();

  Future<List<BlogNews>> getBlogLayout(context) =>
      _memoizer.runOnce(() => widget.categoryId != null
          ? _service.getBlogsByCategory(
              widget.categoryId,
            )
          : _service.getBlogs());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _getBlogsLayout = getBlogLayout(context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          const EdgeInsets.only(left: 5, bottom: 10, top: 5),
                      child: Text(
                        "Related Stories",
                        textAlign: TextAlign.left,
                        style: widget.type == 'fullSizeImageType'
                            ? const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)
                            : TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                      ),
                    ),
                    Container(
                      height: 200,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            for (var i = 0; i < 3; i++)
                              BlogItem(
                                blogs: blogEmptyList,
                                index: i,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));

          case ConnectionState.done:
          default:
            if (snapshot.hasError || snapshot.data == null) {
              return Material(
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Data No internet!',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.only(left: 5, bottom: 10, top: 5),
                  child: Text(
                    "Related Stories",
                    textAlign: TextAlign.left,
                    style: widget.type == 'fullSizeImageType'
                        ? const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                        : TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(snapshot.data.length, (index) {
                        return BlogItem(
                          blogs: snapshot.data,
                          index: index,
                          context: context,
                          type: widget.type,
                        );
                      }),
                    ),
                  ),
//                        child: PageView.builder(
//                            itemCount: snapshot.data.length,
//                            itemBuilder: (context, index) {
//                              return BlogItem(
//                                blogs: snapshot.data,
//                                index: index,
//                                context: context,
//                              );
//                            }),
                )
//
              ],
            );
        }
      },
    );
  }
}

class BlogItem extends StatelessWidget {
  final List<BlogNews> blogs;
  final index;
  final double width;
  final String locale;
  final context;
  final String type;
  BlogItem(
      {this.blogs,
      this.index,
      this.width,
      this.context,
      this.locale = 'en',
      this.type});

  @override
  Widget build(BuildContext context) {
    double imageWidth = (width == null) ? 70 : width;
    double titleFontSize = imageWidth / 6;

    return GestureDetector(
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
        padding: const EdgeInsets.only(left: 5, right: 5),
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(7.0),
                  ),
                  child: Tools.image(
                    url: blogs[index].imageFeature,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: HeartButton(
                    blog: blogs[index],
                    size: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  blogs[index].title,
                  style: type == 'fullSizeImageType'
                      ? TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)
                      : TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  blogs[index].date == ''
                      ? 'Loading ...'
                      : Tools.displayTimeAgoFromTimestamp(blogs[index].date),
                  style: type == 'fullSizeImageType'
                      ? TextStyle(fontSize: titleFontSize, color: Colors.white)
                      : TextStyle(
                          fontSize: titleFontSize,
                          color: Theme.of(context).accentColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
