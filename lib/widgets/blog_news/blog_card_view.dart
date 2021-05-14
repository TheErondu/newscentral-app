import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/blog_news.dart';
import '../../widgets/blog/detailed_blog/blog_view.dart';
import '../common/heart_button.dart';

class BlogCard extends StatelessWidget {
  final BlogNews item;
  final width;
  final marginRight;
  final kSize size;
  final bool isHero;
  final height;

  BlogCard(
      {this.item,
      this.width,
      this.size = kSize.medium,
      this.isHero = false,
      this.height,
      this.marginRight = 5.0});

  Widget getImageFeature(onTapProduct) {
    return GestureDetector(
      onTap: onTapProduct,
      child: isHero
          ? Hero(
              tag: 'product-${item.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                child: Tools.image(
                  url: item.imageFeature,
                  width: width,
                  height: height ?? width * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Tools.image(
                url: item.imageFeature,
                width: width,
                height: height ?? width * 0.6,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

//  onTapProduct(context) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => getDetailPageView(blogs.sublist(index)),
//      ),
//    );
//  }
  onTapProduct(context) {
    //
    if (item.imageFeature == '') return;
//    Provider.of<RecentModel>(context, listen: false).addRecentProduct(item);
    eventBus.fire('detail');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => getDetailBlog(item, context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    double titleFontSize = isTablet ? 14.0 : 14.0;
    const double titleFontSize = 16;
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: marginRight),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  getImageFeature(() => onTapProduct(context)),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: HeartButton(blog: item),
                  )
                ],
              ),
              Container(
                width: width,
                padding: const EdgeInsets.only(top: 10, right: 8, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.date == ''
                          ? 'Loading ...'
                          : Tools.displayTimeAgoFromTimestamp(item.date),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BlogCardCanSwipe extends StatelessWidget {
  final List<BlogNews> blogs;
  final int index;
  final width;
  final marginRight;
  final kSize size;
  final bool isHero;
  final height;

  BlogCardCanSwipe(
      {this.blogs,
      this.index,
      this.width,
      this.size = kSize.medium,
      this.isHero = false,
      this.height,
      this.marginRight = 10.0});

  Widget getImageFeature(onTapProduct) {
    return GestureDetector(
      onTap: onTapProduct,
      child: isHero
          ? Hero(
              tag: 'product-${blogs[index].id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                child: Tools.image(
                  url: blogs[index].imageFeature,
                  width: width,
                  height: height ?? width * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Tools.image(
                url: blogs[index].imageFeature,
                width: width,
                height: height ?? width * 0.7,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  onTapProduct(context) {
    eventBus.fire('detail');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => getDetailPageView(blogs.sublist(index), context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: marginRight),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  getImageFeature(() => onTapProduct(context)),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: HeartButton(blog: blogs[index]),
                  )
                ],
              ),
              Container(
                width: width,
                padding: const EdgeInsets.only(top: 10, right: 8, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      blogs[index].title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      blogs[index].date == ''
                          ? 'Loading ...'
                          : Tools.formatDateString(blogs[index].date),
                      style: TextStyle(
                        color: theme.accentColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
