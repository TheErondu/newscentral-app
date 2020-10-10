import 'package:flutter/material.dart';

import '../../../common/tools.dart';
import '../../../models/blog_news.dart';
import '../../../widgets/blog/detailed_blog/blog_view.dart';
//import '../../../models/product.dart';
//import '../../../screens/detail/index.dart';
//import '../../start_rating.dart';

class BlogSelectCard extends StatelessWidget {
  final BlogNews item;
  final width;
  final marginRight;
  final kSize size;
  final bool isHero;
  final bool showHeart;

  BlogSelectCard(
      {this.item,
      this.width,
      this.size = kSize.medium,
      this.isHero = false,
      this.showHeart = false,
      this.marginRight = 10.0});

  @override
  Widget build(BuildContext context) {
    Future<Widget> getImage() async {
      return ClipRRect(
        child: Tools.image(
          url: item.imageFeature,
          width: width,
          size: kSize.medium,
        ),
        borderRadius: BorderRadius.circular(10),
      );
    }

    void onTapProduct() {
      if (item.imageFeature == '') return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => getDetailBlog(item, context),
        ),
      );
    }

    return GestureDetector(
      onTap: onTapProduct,
      child: Container(
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            FutureBuilder<Widget>(
              future: getImage(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    width: width,
                    height: width * 1.2,
                  );
                }
                return snapshot.data;
              },
            ),
            Container(
              width: width,
              alignment: Alignment.topLeft,
              padding:
                  const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: width,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(
                        top: 10, left: 8, right: 8, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10.0),
                        Text(
                          item.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          Tools.formatDateString(item.date),
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).accentColor.withOpacity(0.5),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
