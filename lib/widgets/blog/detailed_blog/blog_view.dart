import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools.dart';
import '../../../models/app.dart';
import '../../../models/blog_news.dart';
import '../../common/heart_button.dart';
import 'detailed_blog_fullsize_image.dart';
import 'detailed_blog_half_image.dart';
import 'detailed_blog_quarter_image.dart';

Widget getDetailPageView(List<BlogNews> blogs, BuildContext context) {
  return PageView.builder(
    itemCount: blogs.length,
    itemBuilder: (context, position) {
      return getDetailScreen(blogs, position, context);
    },
  );
}

Widget getDetailScreen(List<BlogNews> blogs, index, BuildContext context) {
  var productDetail =
      Provider.of<AppModel>(context).appConfig['Setting']['ProductDetail'];
  var layoutType = productDetail ??
      (kAdvanceConfig['DetailedBlogLayout'] ?? 'oneQuarterSizeImageType');
  Widget layout;
  switch (layoutType) {
    case "halfSizeImageType":
      layout = HalfImageType(item: blogs[index]);
      break;
    case "fullSizeImageType":
      layout = FullImageType(item: blogs[index]);
      break;
    case "oneQuarterSizeImageType":
    default:
      layout = OneQuarterImageType(item: blogs[index]);
      break;
  }
  return layout;
}

Widget getDetailBlog(BlogNews blog, BuildContext context) {
  var productDetail =
      Provider.of<AppModel>(context).appConfig['Setting']['ProductDetail'];
  var layoutType = productDetail ??
      (kAdvanceConfig['DetailedBlogLayout'] ?? 'oneQuarterSizeImageType');
  Widget layout;
  switch (layoutType) {
    case "halfSizeImageType":
      layout = HalfImageType(item: blog);
      break;
    case "fullSizeImageType":
      layout = FullImageType(item: blog);
      break;
    case "oneQuarterSizeImageType":
    default:
      layout = OneQuarterImageType(item: blog);
      break;
  }
  return layout;
}

double _buildBlogFontSize(String type) {
  switch (type) {
    case "twoColumn":
      return 16;
    case "threeColumn":
      return 15;
    case "fourColumn":
      return 13;
    case "recentView":
      return 13;
    case "card":
    default:
      return 13;
  }
}

double _buildProductWidth(screenWidth, String layout) {
  switch (layout) {
    case "twoColumn":
      return screenWidth * 0.5;
    case "threeColumn":
      return screenWidth * 0.35;
    case "fourColumn":
      return screenWidth / 4;
    case "recentView":
      return screenWidth / 4;
    case "card":
    default:
      return screenWidth - 10;
  }
}

class BlogNewsView extends StatelessWidget {
  final List<BlogNews> blogs;
  final int index;

  const BlogNewsView({this.blogs, this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                getDetailPageView(blogs.sublist(index), context),
          ),
        );
      },
      child: ListTile(
        leading: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          alignment: Alignment.center,
          child: Hero(
              tag: 'blog-${blogs[index].id}',
              child: Tools.image(
                  url: blogs[index].imageFeature, size: kSize.medium),
              transitionOnUserGestures: true),
        ),
        title: Text(blogs[index].title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            blogs[index].date,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ),
        dense: false,
      ),
    );
  }
}

class BlogCardView extends StatelessWidget {
  final List<BlogNews> blogs;
  final int index;
  final String type;
  final double width;

  BlogCardView({this.blogs, this.index, this.type, this.width});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                getDetailPageView(blogs.sublist(index), context),
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(right: 0, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: Hero(
                    tag: 'blog-${blogs[index].id}',
                    child: Tools.image(
                      url: blogs[index].imageFeature,
                      width: _buildProductWidth(width, type),
                      height: screenWidth * 0.2,
                      fit: BoxFit.cover,
                      size: kSize.medium,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  blogs[index].title,
                  style: TextStyle(
                      fontSize: _buildBlogFontSize(type),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                ),
                Text(
                  Tools.formatDateString(blogs[index].date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).accentColor.withOpacity(0.5),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
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
    );
  }
}
