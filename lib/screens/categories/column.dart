import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/tools.dart';
import '../../models/blog_news.dart';
import '../../models/category.dart';

class ColumnCategories extends StatefulWidget {
  final List<Category> categories;

  ColumnCategories(this.categories);

  @override
  State<StatefulWidget> createState() {
    return ColumnCategoriesState();
  }
}

class ColumnCategoriesState extends State<ColumnCategories> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
      return GridView(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 0.75,
        ),
        children: List.generate(widget.categories.length, (index) {
          return Container(
            padding: _edgeInsetsForIndex(index),
            child: CategoryColumnItem(widget.categories[index],
                boxConstraints.maxWidth, boxConstraints.maxHeight * 0.75),
          );
        }),
      );
    });
  }

  EdgeInsets _edgeInsetsForIndex(int index) {
    if (index % 2 == 0) {
      return const EdgeInsets.only(
          top: 4.0, left: 4.0, right: 4.0, bottom: 4.0);
    } else {
      return const EdgeInsets.only(
          top: 4.0, left: 4.0, right: 4.0, bottom: 4.0);
    }
  }
}

class CategoryColumnItem extends StatelessWidget {
  final Category category;
  final double screenWidth;
  final double screenHeight;
  CategoryColumnItem(this.category, this.screenWidth, this.screenHeight);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BlogNews.showList(
          context: context, cateId: category.id, cateName: category.name),
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenWidth * 0.75,
//              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              child: Tools.image(
                url: CategoryStaticImages[category.id],
                fit: BoxFit.cover,
              ),
            ),
            Container(
                color: const Color.fromRGBO(0, 0, 0, 0.4),
                child: Center(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
