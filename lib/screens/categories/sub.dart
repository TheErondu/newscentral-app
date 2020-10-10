import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/app.dart';
import '../../models/blog_news.dart';
import '../../models/category.dart';
import '../../services/wordpress.dart';
import '../../widgets/blog/detailed_blog/blog_view.dart';

class SubCategories extends StatefulWidget {
  final List<Category> categories;
  SubCategories(this.categories);

  @override
  State<StatefulWidget> createState() {
    return SubCategoriesState();
  }
}

class SubCategoriesState extends State<SubCategories> {
  int selectedIndex = 0;
  final WordPress _service = WordPress();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: Text(widget.categories[index].name,
                        style: TextStyle(
                            fontSize: 18,
                            color: selectedIndex == index
                                ? theme.primaryColor
                                : theme.hintColor)),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FutureBuilder<List<BlogNews>>(
                future: _service.fetchBlogsByCategory(
                    lang: Provider.of<AppModel>(context, listen: false).locale,
                    categoryId: widget.categories[selectedIndex].id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<BlogNews>> snapshot) {
                  if (!snapshot.hasData) {
                    return kLoadingWidget(context);
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: List.generate(
                        snapshot.data.length,
                        (index) {
                          return BlogCardView(
                            blogs: snapshot.data,
                            index: index,
                            width: constraints.maxWidth,
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
